# frozen_string_literal: true

module FundLoadAttempts
  class ImportJob < ApplicationJob
    sidekiq_options retry: false

    def perform(attempt_line, line_number)
      parsed_attempt_line = JSON.parse(attempt_line, symbolize_names: true)
      fund_load_attempt = ImportService.call(attributes: parsed_attempt_line)
      AdjudicateService.call(fund_load_attempt:)
    rescue JSON::ParseError => _e
      Rails.logger.error("Invalid fund load attempt: #{attempt_line} at line #{line_number}")
      raise
    end
  end
end
