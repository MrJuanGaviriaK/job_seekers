require 'swagger_helper'

RSpec.describe 'API V1 Opportunities', type: :request do
  path '/api/v1/opportunities' do
    get 'List opportunities' do
      tags 'Opportunities'
      produces 'application/json'
      parameter name: :search, in: :query, type: :string, description: 'Search by title'
      parameter name: :page, in: :query, type: :integer, description: 'Page number'

      response '200', 'opportunities listed' do
        let(:search) { 'developer' }
        let(:page) { 1 }

        run_test!
      end
    end

    post 'Create opportunity' do
      tags 'Opportunities'
      consumes 'application/json'
      parameter name: :opportunity, in: :body, schema: {
        type: :object,
        properties: {
          client_id: { type: :integer },
          title: { type: :string },
          description: { type: :string },
          salary: { type: :integer }
        },
        required: %w[client_id title description salary]
      }

      response '201', 'opportunity created' do
        let(:opportunity) do
          {
            client_id: Client.create!(name: 'Acme').id,
            title: 'Senior Dev',
            description: 'Rails + Sidekiq role',
            salary: 100_000
          }
        end

        run_test!
      end
    end

    path '/api/v1/opportunities/{id}/apply' do
      post 'Job seeker applies to opportunity' do
        tags 'Opportunities'
        consumes 'application/json'
        parameter name: :id, in: :path, type: :string
        parameter name: :job_seeker_id, in: :query, type: :integer

        response '200', 'application successful' do
          let(:client) { Client.create!(name: 'Foo Corp') }
          let(:opportunity) { client.opportunities.create!(title: 'Junior Dev', description: 'Remote', salary: 80000) }
          let(:id) { opportunity.id }
          let(:job_seeker_id) { JobSeeker.create!(name: 'Alice', email: 'alice@example.com').id }

          run_test!
        end
      end
    end
  end
end
