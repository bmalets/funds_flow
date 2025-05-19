# frozen_string_literal: true

module FundLoadAttempts
  class AdjudicateService < BaseService
    DAILY_LIMIT_CENTS = 500000
    WEEKLY_LIMIT_CENTS = 2000000
    MAX_DAILY_ATTEMPTS_COUNT = 3

    def initialize(fund_load_attempt:)
      @fund_load_attempt = fund_load_attempt
    end

    def call
      @fund_load_attempt.update!(accepted: accepted?)
    end

    private

    def accepted?
      daily_limit_not_reached? && weekly_limit_not_reached? && daily_attempts_count_not_reached?
    end

    def daily_limit_not_reached?
      @fund_load_attempt.amount_cents <= DAILY_LIMIT_CENTS && daily_total_cents <= DAILY_LIMIT_CENTS
    end

    def daily_total_cents
      FundLoadAttempt.where(customer_id: @fund_load_attempt.customer_id,
                            attempted_at: @fund_load_attempt.attempted_at.all_day)
                     .sum(:amount_cents)
    end

    def weekly_limit_not_reached?
      @fund_load_attempt.amount_cents <= WEEKLY_LIMIT_CENTS && weekly_total_cents <= WEEKLY_LIMIT_CENTS
    end

    def weekly_total_cents
      FundLoadAttempt.where(customer_id: @fund_load_attempt.customer_id,
                            attempted_at: @fund_load_attempt.attempted_at.all_week)
                     .sum(:amount_cents)
    end

    def daily_attempts_count_not_reached?
      daily_attempts_count <= MAX_DAILY_ATTEMPTS_COUNT
    end

    def daily_attempts_count
      FundLoadAttempt.where(customer_id: @fund_load_attempt.customer_id,
                            attempted_at: @fund_load_attempt.attempted_at.all_day)
                     .count
    end
  end
end
