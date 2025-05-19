# frozen_string_literal: true

module FundLoadAttempts
  class ImportService < BaseService
    def initialize(attributes:, fund_load_attempts_import:)
      @attributes = attributes
      @fund_load_attempts_import = fund_load_attempts_import
      super
    end

    def call
      ApplicationRecord.transaction do
        customer = Customer.find_or_create_by!(customer_attributes)
        customer.fund_load_attempts.create!(fund_load_attempt_attributes)
      end
    rescue ActiveRecord::RecordInvalid => e
      raise ::Errors::FundLoadAttemptImportFailed, "Attempt creation failed: #{e.message}. Attributes: #{@attributes}"
    end

    private

    def customer_attributes
      {
        external_id: @attributes.fetch(:customer_id).presence&.to_i
      }
    end

    def fund_load_attempt_attributes
      {
        fund_load_attempts_import_id: @fund_load_attempts_import.id,
        external_id: @attributes.fetch(:id).presence&.to_i,
        attempted_at: @attributes.fetch(:time),
        amount_cents:
      }
    end

    def amount_cents
      amount = @attributes.fetch(:load_amount)
      Monetize.parse(amount).cents
    end
  end
end
