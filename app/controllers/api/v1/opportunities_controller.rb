# frozen_string_literal: true

module Api
  module V1
    class OpportunitiesController < ApplicationController
      def index
        opportunities = SearchOpportunitiesService.new(
          search: params[:search],
          page: params[:page]
        ).call

        render json: opportunities.as_json(include: { client: { only: :name } })
      end

      def create
        service = CreateOpportunityService.new(
          client_id: opportunity_params[:client_id],
          opportunity_params: opportunity_params
        ).call

        if service.success?
          render json: service.data, status: :created
        else
          render json: { errors: service.errors }, status: :unprocessable_entity
        end
      end

      def apply
        service = ApplyToOpportunityService.new(
          opportunity_id: params[:id],
          job_seeker_id: params[:job_seeker_id]
        ).call

        if service.success?
          render json: { message: service.data[:message] }, status: :ok
        else
          render json: { errors: service.errors }, status: :unprocessable_entity
        end
      end

      private

      def opportunity_params
        params.require(:opportunity).permit(:title, :description, :salary, :client_id)
      end
    end
  end
end
