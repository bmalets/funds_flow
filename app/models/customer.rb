# frozen_string_literal: true

class Customer < ApplicationRecord
  has_many :fund_load_attempts, dependent: :destroy

  validates :external_id, presence: true, uniqueness: true
end
