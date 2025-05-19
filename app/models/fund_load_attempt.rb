# frozen_string_literal: true

class FundLoadAttempt < ApplicationRecord
  belongs_to :customer
  belongs_to :fund_load_attempts_import

  monetize :amount_cents

  validates :amount_cents, presence: true, numericality: { greater_than: 0 }
  validates :external_id, presence: true, uniqueness: true
  validates :customer_id, uniqueness: { scope: :external_id }
  validates :attempted_at, presence: true
end
