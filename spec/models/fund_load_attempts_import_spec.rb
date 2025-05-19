# frozen_string_literal: true

require 'rails_helper'

describe FundLoadAttemptsImport do
  context 'with attributes' do
    it { is_expected.to respond_to :status }
    it { is_expected.to respond_to :fund_load_attempts_count }
  end

  describe 'associations' do
    it { is_expected.to have_many(:fund_load_attempts).dependent(:destroy) }
  end

  describe 'enums' do
    subject(:fund_load_attempts_import) { build(:fund_load_attempts_import) }

    it {
      expect(fund_load_attempts_import).to define_enum_for(:status)
        .with_values(pending: 'pending', failed: 'failed', created: 'created')
        .backed_by_column_of_type(:enum)
        .with_prefix(:status)
    }
  end
end
