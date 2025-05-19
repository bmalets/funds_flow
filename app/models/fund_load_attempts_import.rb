# frozen_string_literal: true

class FundLoadAttemptsImport < ApplicationRecord
  include AASM

  enum :status, { pending: 'pending', failed: 'failed', created: 'created' }, validate: true, prefix: true

  has_many :fund_load_attempts, dependent: :destroy

  aasm column: :status, enum: true do
    state :pending, initial: true
    state :failed
    state :created

    event :fail do
      transitions from: %i[pending failed], to: :failed
    end

    event :finish do
      transitions from: :pending, to: :created
    end
  end
end
