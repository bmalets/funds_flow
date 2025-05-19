# frozen_string_literal: true

module FundLoadAttempts
  module Adjudication
    class WeeklyLimitCheckService < BaseCheckService
      WEEKLY_LIMIT_CENTS = 2_000_000

      def call
        @fund_load_attempt.amount_cents <= WEEKLY_LIMIT_CENTS && weekly_total_cents <= WEEKLY_LIMIT_CENTS
      end

      private

      def weekly_total_cents
        FundLoadAttempt.where(customer_id: @fund_load_attempt.customer_id,
                              attempted_at: @fund_load_attempt.attempted_at.all_week)
                       .sum(:amount_cents)
      end
    end
  end
end
