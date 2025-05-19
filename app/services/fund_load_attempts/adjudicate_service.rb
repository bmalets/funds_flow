# frozen_string_literal: true

module FundLoadAttempts
  class AdjudicateService < BaseService
    def initialize(fund_load_attempt:)
      @fund_load_attempt = fund_load_attempt
      super
    end

    def call
      @fund_load_attempt.update!(accepted: accepted?)
    end

    private

    def accepted?
      daily_limit_not_reached? &&
        weekly_limit_not_reached? &&
        daily_attempts_count_not_reached? &&
        passes_prime_id_sanctions? &&
        passes_monday_sanctions?
    end

    def daily_limit_not_reached?
      Adjudication::DailyLimitCheckService.call(fund_load_attempt: @fund_load_attempt)
    end

    def weekly_limit_not_reached?
      Adjudication::WeeklyLimitCheckService.call(fund_load_attempt: @fund_load_attempt)
    end

    def daily_attempts_count_not_reached?
      Adjudication::DailyCountCheckService.call(fund_load_attempt: @fund_load_attempt)
    end

    def passes_prime_id_sanctions?
      Adjudication::PrimeIdCheckService.call(fund_load_attempt: @fund_load_attempt)
    end

    def passes_monday_sanctions?
      Adjudication::MondayCheckService.call(fund_load_attempt: @fund_load_attempt)
    end
  end
end
