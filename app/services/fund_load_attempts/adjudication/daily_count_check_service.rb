# frozen_string_literal: true

module FundLoadAttempts
  module Adjudication
    class DailyCountCheckService < BaseCheckService
      MAX_DAILY_ATTEMPTS_COUNT = 3

      def call
        daily_attempts_count <= MAX_DAILY_ATTEMPTS_COUNT
      end

      private

      def daily_attempts_count
        FundLoadAttempt.where(customer_id: @fund_load_attempt.customer_id,
                              attempted_at: @fund_load_attempt.attempted_at.all_day)
                       .count
      end
    end
  end
end
