require 'rails_helper'

RSpec.describe JobApplicationNotifierJob, type: :job do
  let(:client) { Client.create!(name: Faker::Company.unique.name) }
  let(:application) do
    JobApplication.create!(job_seeker: job_seeker, opportunity: opportunity)
  end
  let!(:job_seeker) do
    JobSeeker.create!(
      name: 'Alice',
      email: Faker::Internet.unique.email
    )
  end
  let!(:opportunity) do
    client.opportunities.create!(
      title: 'Senior Dev',
      description: Faker::Lorem.paragraph(sentence_count: 3),
      salary: rand(50_000..150_000)
    )
  end

  describe '#perform' do
    it 'logs a message about the job application' do
      expect(Rails.logger).to receive(:info).with(
        "Job Seeker Alice applied to Senior Dev"
      )

      described_class.new.perform(application.id)
    end
  end

  describe 'enqueuing the job' do
    it 'enqueues the job with correct arguments' do
      expect {
        described_class.perform_later(application.id)
      }.to have_enqueued_job(described_class).with(application.id).on_queue('default')
    end
  end
end
