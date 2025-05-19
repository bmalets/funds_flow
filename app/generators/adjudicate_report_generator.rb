# frozen_string_literal: true

class AdjudicateReportGenerator < BaseService
  def initialize(fund_load_attempts_import:)
    @fund_load_attempts_import = fund_load_attempts_import
    super
  end

  def call
    lines = prepare_lines

    Rails.root.join(ENV.fetch('FUND_LOAD_ATTEMPTS_OUTPUT_FILE_NAME'))
         .write(lines.join("\n"))
  end

  private

  def prepare_lines
    lines = []
    collection.find_in_batches do |batch|
      lines += batch.map { |record| format_line(record) }
    end

    lines
  end

  def collection
    @fund_load_attempts_import.fund_load_attempts
                              .joins(:customer)
                              .select(FundLoadAttempt.arel_table[:id],
                                      FundLoadAttempt.arel_table[:external_id],
                                      Customer.arel_table[:external_id].as('customer_external_id'),
                                      FundLoadAttempt.arel_table[:accepted])
                              .order(id: :asc)
  end

  def format_line(record)
    {
      id: record.external_id.to_s,
      customer_id: record.customer_external_id.to_s,
      accepted: record.accepted
    }.to_json
  end
end
