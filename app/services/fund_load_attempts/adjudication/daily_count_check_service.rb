# frozen_string_literal: true

module FundLoadAttempts
  module Adjudication
    class DailyLimitCheckService < BaseService
      DAILY_LIMIT_CENTS = 500000

      def initialize(fund_load_attempt:)
        @fund_load_attempt = fund_load_attempt
      end

      def call
        @fund_load_attempt.amount_cents <= DAILY_LIMIT_CENTS && daily_total_cents <= DAILY_LIMIT_CENTS
      end

      private

      def daily_total_cents
        FundLoadAttempt.where(customer_id: @fund_load_attempt.customer_id,
                              attempted_at: @fund_load_attempt.attempted_at.all_day)
                       .sum(:amount_cents)
      end
    end
  end
end
