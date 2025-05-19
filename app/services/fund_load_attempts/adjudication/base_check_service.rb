# frozen_string_literal: true

module FundLoadAttempts
  module Adjudication
    class BaseCheckService < BaseService
      def initialize(fund_load_attempt:)
        @fund_load_attempt = fund_load_attempt
        super
      end
    end
  end
end
