# frozen_string_literal: true

require 'rails_helper'
require 'faker'

RSpec.describe 'Api::V1::OpportunitiesController', type: :request do
  let!(:client) { Client.create!(name: Faker::Company.unique.name) }
  let!(:job_seeker) do
    JobSeeker.create!(
      name: Faker::Name.name,
      email: Faker::Internet.unique.email
    )
  end
  let!(:opportunities) do
    [client.opportunities.create!(
      title: 'Developer',
      description: Faker::Lorem.paragraph(sentence_count: 3),
      salary: rand(50_000..150_000)
    )]
  end

  describe 'GET /api/v1/opportunities' do
    it 'returns paginated and searchable opportunities' do
      get '/api/v1/opportunities', params: { search: 'Developer', page: 1 }

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.size).to eq(1)
      expect(body.first['client']['name']).to eq(client.name)
    end
  end

  describe 'POST /api/v1/opportunities' do
    context 'with valid params' do
      let(:valid_params) do
        {
          opportunity: {
            title: 'New Role',
            description: 'Awesome job',
            salary: 100_000,
            client_id: client.id
          }
        }
      end

      it 'creates a new opportunity' do
        post '/api/v1/opportunities', params: valid_params

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['title']).to eq('New Role')
      end
    end

    context 'with invalid params' do
      let(:invalid_params) do
        {
          opportunity: {
            title: '',
            description: '',
            salary: nil,
            client_id: client.id
          }
        }
      end

      it 'returns errors' do
        post '/api/v1/opportunities', params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['errors']).to be_an(Array)
      end
    end

    context 'when the client does not exist' do
      let(:invalid_params) do
        {
          opportunity: {
            title: 'New Role',
            description: 'Awesome job',
            salary: 100_000,
            client_id: 1000
          }
        }
      end

      it 'returns errors' do
        post '/api/v1/opportunities', params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['errors']).to be_an(Array)
      end
    end
  end

  describe 'POST /api/v1/opportunities/:id/apply' do
    let(:opportunity) { opportunities.first }

    context 'with valid job seeker' do
      it 'creates a job application and triggers a job' do
        expect {
          post "/api/v1/opportunities/#{opportunity.id}/apply", params: { job_seeker_id: job_seeker.id }
        }.to have_enqueued_job(JobApplicationNotifierJob)

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Applied successfully')
      end
    end

    context 'with invalid job seeker id' do
      before do
        JobApplication.create!(job_seeker: job_seeker, opportunity: opportunities.first)
      end

      it 'returns not found error' do
        post "/api/v1/opportunities/#{opportunity.id}/apply", params: { job_seeker_id: 0 }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include('Record not found: JobSeeker')
      end

      it 'returns error if job seeker has already applied' do
        post "/api/v1/opportunities/#{opportunity.id}/apply", params: { job_seeker_id: job_seeker.id }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include('Job seeker has already been taken')
      end
    end
  end
end
