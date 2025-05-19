# frozen_string_literal: true

class FundLoadImport < ApplicationRecord
  has_many :fund_load_attempts, dependent: :destroy
end
