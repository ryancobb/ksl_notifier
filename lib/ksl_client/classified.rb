require 'ksl_client/base_client'

module KslClient
  class Classified 
    include BaseClient

    RESOURCE = 'classifieds'.freeze
    SERVICE = 'search'.freeze

    def initialize(query_params)
      @query_params = query_params
      @browser = ::Browser::Client.new
    end

    private

    def create_listing(listing)
      ::Listing.new(
        :title => listing.css('.title a').children.text.squish,
        :short_description => listing.css('.description-text > text()').text.squish, 
        :location => listing.css('.address').text.squish,
        :link => listing.css('.link').attr('href').value,
        :price_cents => listing.css('.listing-detail-line.price > text()').text.squish.gsub(/[$,]/,'').to_f*100
      )
    end
  end
end