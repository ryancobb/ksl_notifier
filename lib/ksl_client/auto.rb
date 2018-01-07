require 'ksl_client/base_client'

module KslClient
  class Auto
    include BaseClient

    RESOURCE = 'auto/search'.freeze
    SERVICE = 'index'.freeze

    def initialize(query_params)
      @query_params = query_params
      @browser = ::Browser::Client.new
    end

    private

    def create_listing(listing)
      ::Listing.new(
        :title => listing.css('.title a').children.text.squish,
        :short_description => listing.css('.srp-listing-description > text()').text.squish, 
        :location => listing.css('.listing-detail-line text()')[2].text.gsub(/[|]/, '').squish,
        :link => clean_link(listing.css('.link').attr('href').value),
        :price_cents => listing.css('.listing-detail-line.price > text()').text.squish.gsub(/[$,]/,'').to_f*100,
        :photo_url => listing.css('.photo img').attr('src').value
      )
    end
  end
end