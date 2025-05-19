# frozen_string_literal: true

module FundLoadAttempts
  class ImportJob < ApplicationJob
    sidekiq_options retry: false

    def perform(attempt_line, fund_load_attempts_import_id, line_number)
      parsed_attempt_line = JSON.parse(attempt_line, symbolize_names: true)
      fund_load_attempts_import = FundLoadAttemptsImport.find_by(id: fund_load_attempts_import_id)
      return if fund_load_attempts_import.status_failed?

      fund_load_attempt = import_attempt(parsed_attempt_line, fund_load_attempts_import)
      adjudicate_attempt(fund_load_attempt)
    rescue JSON::ParserError => _e
      fail_import(fund_load_attempts_import, "Invalid fund load attempt: #{attempt_line} at line #{line_number}")
    rescue ::Errors::FundLoadAttemptImportFailed => e
      fail_import(fund_load_attempts_import, e.message)
    end

    private

    def import_attempt(attributes, fund_load_attempts_import)
      ImportService.call(attributes:, fund_load_attempts_import:)
    end

    def adjudicate_attempt(fund_load_attempt)
      AdjudicateJob.perform_later(fund_load_attempt.id)
    end

    def fail_import(fund_load_attempts_import, error_message)
      Rails.logger.error(error_message)
      fund_load_attempts_import.fail!
    end
  end
end
