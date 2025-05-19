# frozen_string_literal: true

module FundLoadAttempts
  class ImportFileJob < ApplicationJob
    sidekiq_options retry: 10

    def perform
      return log_file_absence unless File.exist?(fund_load_attempts_file)

      import_line_jobs = parse_file_to_jobs
      return if import_line_jobs.empty?

      fund_load_attempts_import.update!(fund_load_attempts_count: import_line_jobs.count)
      ActiveJob.perform_all_later(import_line_jobs)
    end

    private

    def parse_file_to_jobs
      jobs = []

      File.foreach(fund_load_attempts_file) do |line, line_number|
        next if line.blank?

        jobs << import_line_job(line, line_number)
      end

      jobs
    end

    def fund_load_attempts_import
      @fund_load_attempts_import ||= FundLoadAttemptsImport.create!
    end

    def fund_load_attempts_file
      @fund_load_attempts_file ||= Rails.root.join(ENV.fetch('FUND_LOAD_ATTEMPTS_INPUT_FILE_NAME'))
    end

    def log_file_absence
      Rails.logger.error("Fund load attempts file absent (path: #{fund_load_attempts_file})")
    end

    def import_line_job(line, line_number)
      ImportLineJob.new(line, fund_load_attempts_import.id, line_number)
    end
  end
end
