require 'ksl_client/base_client'

module KslClient
  class Auto < BaseClient
    RESOURCE = "auto/search".freeze
    SERVICE = "index".freeze

    def initialize(search_query)
      super(RESOURCE, SERVICE, search_query)
    end

    def results
      @results ||= parse_results
    end

    private

    def create_listing(listing)
      new_listing = ::Listing.create!(
        :title => listing.css('.title a').children.text.squish,
        :short_description => listing.css('.srp-listing-description > text()').text.squish, 
        :location => listing.css('.listing-detail-line text()')[2].text.gsub(/[|]/, '').squish,
        :link => listing.css('.link').attr('href').value,
        :price_cents => listing.css('.listing-detail-line.price > text()').text.squish.gsub(/[$,]/,'').to_f*100
      )
    end
  end
end