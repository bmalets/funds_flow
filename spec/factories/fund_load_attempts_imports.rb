# frozen_string_literal: true

FactoryBot.define do
  factory :fund_load_attempts_import do
    status { FundLoadAttemptsImport.statuses.values.sample }
    fund_load_attempts_count { Faker::Number.number(digits: 1) }
  end
end
