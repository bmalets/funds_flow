# frozen_string_literal: true

class GenerateAdjudicateReportJob < ApplicationJob
  sidekiq_options retry: false

  def perform(fund_load_attempts_import_id)
    fund_load_attempts_import = FundLoadAttemptsImport.status_created
                                                      .find_by(id: fund_load_attempts_import_id)
    return unless fund_load_attempts_import

    generate_report(fund_load_attempts_import)
  end

  private

  def generate_report(fund_load_attempts_import)
    AdjudicateReportGenerator.call(fund_load_attempts_import:)
  end
end
