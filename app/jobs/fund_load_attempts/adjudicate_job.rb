# frozen_string_literal: true

module FundLoadAttempts
  class AdjudicateJob < ApplicationJob
    sidekiq_options retry: false

    def perform(fund_load_attempt_id)
      fund_load_attempt = FundLoadAttempt.includes(:fund_load_attempts_import)
                                         .find_by(id: fund_load_attempt_id)
      return unless fund_load_attempt

      fund_load_attempts_import = fund_load_attempt.fund_load_attempts_import
      return if fund_load_attempts_import.status_failed?

      process_attempt(fund_load_attempt)
      return unless import_finished?(fund_load_attempts_import)

      fund_load_attempts_import.finish!
      generate_report(fund_load_attempts_import)
    end

    private

    def process_attempt(fund_load_attempt)
      AdjudicateService.call(fund_load_attempt:)
    end

    def import_finished?(fund_load_attempts_import)
      all_attempts_count = fund_load_attempts_import.fund_load_attempts_count
      processed_attempts_count = calculate_processed_attempts_count(fund_load_attempts_import)

      all_attempts_count == processed_attempts_count
    end

    def calculate_processed_attempts_count(fund_load_attempts_import)
      fund_load_attempts_import.fund_load_attempts
                               .where.not(accepted: nil)
                               .count
    end

    def generate_report(fund_load_attempts_import)
      GenerateAdjudicateReportJob.perform_later(fund_load_attempts_import.id)
    end
  end
end
