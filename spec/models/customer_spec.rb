# frozen_string_literal: true

require 'rails_helper'

describe Customer do
  context 'with attributes' do
    it { is_expected.to respond_to :external_id }
  end

  describe 'associations' do
    it { is_expected.to have_many(:fund_load_attempts).dependent(:destroy) }
  end

  describe 'validations' do
    subject { build(:customer) }

    it { is_expected.to validate_uniqueness_of(:external_id) }
  end
end
