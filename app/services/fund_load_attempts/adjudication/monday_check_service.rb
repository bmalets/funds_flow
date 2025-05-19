# frozen_string_literal: true

module FundLoadAttempts
  module Adjudication
    class PrimeIdCheckService < BaseCheckService
      PRIME_DAILY_LIMIT_CENTS = 999900
      PRIME_MAX_DAILY_ATTEMPTS_COUNT = 1

      def call
        prime_external_id? && valid_amount? && first_attempt?
      end

      private

      def prime_external_id?
        Prime.prime?(@fund_load_attempt.external_id)
      end

      def valid_amount?
        @fund_load_attempt.amount_cents <= PRIME_DAILY_LIMIT_CENTS
      end

      def first_attempt?
        daily_total_count == PRIME_MAX_DAILY_ATTEMPTS_COUNT
      end

      def daily_total_count
        FundLoadAttempt.where(customer_id: @fund_load_attempt.customer_id,
                              attempted_at: @fund_load_attempt.attempted_at.all_day)
                       .count
      end
    end
  end
end
