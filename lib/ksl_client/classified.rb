require 'ksl_client/base_client'

module KslClient
  class Classified < BaseClient
    RESOURCE = "classifieds".freeze
    SERVICE = "search".freeze

    def initialize(search_query)
      super(RESOURCE, SERVICE, search_query)
    end

    def results
      @results ||= parse_results
    end

    private

    def create_listing(listing)
      new_listing = ::Listing.new(
        :title => listing.css('.title a').children.text.squish,
        :short_description => listing.css('.description-text > text()').text.squish, 
        :location => listing.css('.address').text.squish,
        :link => listing.css('.link').attr('href').value,
        :price_cents => listing.css('.listing-detail-line.price > text()').text.squish.gsub(/[$,]/,'').to_f*100
      )
    end
  end
end