# frozen_string_literal: true

class CreateOpportunityService
  include ServiceResponse

  def initialize(client_id:, opportunity_params:)
    @client_id = client_id
    @opportunity_params = opportunity_params
  end

  def call
    client = Client.find(@client_id)
    opportunity = client.opportunities.build(@opportunity_params)

    if opportunity.save
      ServiceResponse::Success.new(opportunity)
    else
      ServiceResponse::Error.new(opportunity.errors.full_messages)
    end
  rescue ActiveRecord::RecordNotFound => e
    ServiceResponse::Error.new(["Client not found"])
  end
end
