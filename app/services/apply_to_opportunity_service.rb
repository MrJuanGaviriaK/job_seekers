# frozen_string_literal: true

class ApplyToOpportunityService
  include ServiceResponse

  def initialize(opportunity_id:, job_seeker_id:)
    @opportunity_id = opportunity_id
    @job_seeker_id = job_seeker_id
  end

  def call
    opportunity = Opportunity.find(@opportunity_id)
    job_seeker = JobSeeker.find(@job_seeker_id)

    application = opportunity.job_applications.create(job_seeker: job_seeker)

    if application.persisted?
      JobApplicationNotifierJob.perform_later(application.id)
      ServiceResponse::Success.new({ message: 'Applied successfully' })
    else
      ServiceResponse::Error.new(application.errors.full_messages)
    end
  rescue ActiveRecord::RecordNotFound => e
    ServiceResponse::Error.new(["Record not found: #{e.model}"])
  end
end
