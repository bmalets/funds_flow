# frozen_string_literal: true

require 'rails_helper'

describe FundLoadAttempts::Adjudication::WeeklyLimitCheckService do
  subject(:service_call) { described_class.call(fund_load_attempt:) }

  let(:fund_load_attempt) { build(:fund_load_attempt) }

  shared_examples 'passes weekly limit check' do
    context 'when amount is too big' do
      let(:amount_cents) { 2_000_001 }

      it { is_expected.to be(false) }
    end

    context 'when valid amount' do
      let(:amount_cents) { Faker::Number.between(from: 1, to: 2_000_000) }

      it { is_expected.to be(true) }
    end
  end

  # @fund_load_attempt.amount_cents <= WEEKLY_LIMIT_CENTS && weekly_total_cents <= WEEKLY_LIMIT_CENTS
  context 'when first customer attempt' do
    let(:fund_load_attempt) { create(:fund_load_attempt, amount_cents:) }

    it_behaves_like 'passes weekly limit check'
  end

  context 'when customer has existing attempts last week' do
    let(:fund_load_attempt) { create(:fund_load_attempt, amount_cents:) }

    before do
      create(:fund_load_attempt,
             amount_cents: 2_000_000,
             customer: fund_load_attempt.customer,
             attempted_at: 1.week.before(fund_load_attempt.attempted_at))
    end

    it_behaves_like 'passes weekly limit check'
  end

  context 'when customer has existing attempts this week' do
    let(:fund_load_attempt) { create(:fund_load_attempt, amount_cents:) }

    before do
      create(:fund_load_attempt,
             amount_cents: 1_999_999,
             customer: fund_load_attempt.customer,
             attempted_at: fund_load_attempt.attempted_at.beginning_of_day)
    end

    context 'when amount is too big' do
      let(:amount_cents) { 2 }

      it { is_expected.to be(false) }
    end

    context 'when valid amount' do
      let(:amount_cents) { 1 }

      it { is_expected.to be(true) }
    end
  end
end
