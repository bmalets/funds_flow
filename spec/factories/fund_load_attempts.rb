# frozen_string_literal: true

FactoryBot.define do
  factory :fund_load_attempt do
    fund_load_attempts_import
    customer

    amount_cents { Faker::Number.number(digits: 5) }
    attempted_at { Faker::Time.between(from: 1.month.ago, to: 1.day.ago) }
    sequence(:external_id)
  end
end
