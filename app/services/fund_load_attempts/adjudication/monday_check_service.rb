# frozen_string_literal: true

module FundLoadAttempts
  module Adjudication
    class MondayCheckService < BaseCheckService
      INCREASE_COEFFICIENT = 2

      def call
        return true unless @fund_load_attempt.attempted_at.monday?

        daily_limit_not_reached? &&
          weekly_limit_not_reached? &&
          daily_attempts_count_not_reached? &&
          passes_prime_id_sanctions?
      end

      private

      def increased_amount_attempt
        @increased_amount_attempt ||= FundLoadAttempt.new(customer_id: @fund_load_attempt.customer_id,
                                                          attempted_at: @fund_load_attempt.attempted_at,
                                                          external_id: @fund_load_attempt.external_id,
                                                          amount_cents: increased_amount_cents)
      end

      def increased_amount_cents
        @fund_load_attempt.amount_cents * INCREASE_COEFFICIENT
      end

      def daily_limit_not_reached?
        DailyLimitCheckService.call(fund_load_attempt: increased_amount_attempt)
      end

      def weekly_limit_not_reached?
        WeeklyLimitCheckService.call(fund_load_attempt: increased_amount_attempt)
      end

      def daily_attempts_count_not_reached?
        DailyCountCheckService.call(fund_load_attempt: increased_amount_attempt)
      end

      def passes_prime_id_sanctions?
        PrimeIdCheckService.call(fund_load_attempt: increased_amount_attempt)
      end
    end
  end
end
