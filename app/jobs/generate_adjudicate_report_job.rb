# frozen_string_literal: true

module FundLoadAttempts
  class AdjudicateJob < ApplicationJob
    sidekiq_options retry: false

    def perform(fund_load_attempt_id)
      fund_load_attempt = FundLoadAttempt.includes(:fund_load_attempts_import)
                                         .find_by(id: fund_load_attempt_id)
      return unless fund_load_attempt

      process_attempt(fund_load_attempt)
      return unless import_finished?(fund_load_attempt)

      generate_report(fund_load_attempts_import)
    end

    private

    def import_finished?(fund_load_attempts_import)
      fund_load_attempts_import.fund_load_attempts
                               .where(accepted: nil)
                               .none?
    end

    def process_attempt(fund_load_attempt)
      AdjudicateService.call(fund_load_attempt:)
    end

    def generate_report(fund_load_attempts_import)
      AdjudicateReportGenerator.call(fund_load_attempts_import:)
    end
  end
end
