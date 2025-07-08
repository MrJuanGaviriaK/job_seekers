# frozen_string_literal: true

class JobApplicationNotifierJob < ApplicationJob
  queue_as :default

  def perform(application_id)
    application = JobApplication.find(application_id)
    Rails.logger.info("Job Seeker #{application.job_seeker.name} applied to #{application.opportunity.title}")
  end
end
