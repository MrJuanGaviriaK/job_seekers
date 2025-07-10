# frozen_string_literal: true
class SearchOpportunitiesService
  def initialize(search:, page:)
    @search_query = search.presence || ''
    @page = page.presence || 1
  end

  def call
    cache_key = "opportunities:search:#{@search_query}:page:#{@page}"

    Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
      Opportunity.includes(:client)
                 .where("title ILIKE ?", "%#{@search_query}%")
                 .page(@page)
                 .per(10)
                 .to_a
    end
  end
end
