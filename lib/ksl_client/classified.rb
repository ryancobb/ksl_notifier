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
        :title => listing.css('.item-info-title-link').text.squish,
        :short_description => listing.css('.item-description.info-line > text()').text.squish,
        :location => listing.css(".address").text.squish,
        :link => listing.css('.item-info-title-link').attr('href').value,
        :price_cents => listing.css('.item-info-price.info-line').text.squish.gsub(/[$,]/,'').to_f*100,
        :photo_url => nil
      )
    end

    def listings(html_doc)
      html_doc.css('.listing-item.normal')
    end
  end
end