# frozen_string_literal: true

FactoryBot.define do
  factory :customer do
    sequence(:external_id)
  end
end
