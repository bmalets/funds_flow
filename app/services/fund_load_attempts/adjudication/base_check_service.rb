# frozen_string_literal: true

module FundLoadAttempts
  module Adjudication
    class DailyBaseCheckService < BaseService
      def initialize(fund_load_attempt:)
        @fund_load_attempt = fund_load_attempt
      end

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
