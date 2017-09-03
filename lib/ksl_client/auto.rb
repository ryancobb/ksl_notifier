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
      new_listing = ::Listing.new(
        :title => listing.css('.title a').children.text.squish,
        :short_description => listing.css('.srp-listing-description > text()').text.squish, 
        :location => listing.css('.listing-detail-line text()')[2].text.gsub(/[|]/, '').squish,
        :link => clean_link(listing.css('.link').attr('href').value),
        :price_cents => listing.css('.listing-detail-line.price > text()').text.squish.gsub(/[$,]/,'').to_f*100,
        :photo_url => listing.css('.photo img').attr('src').value
      )
    end

    def clean_link(link)
      uri = set_uri(link)

      uri.query = nil
      BASE_URL + uri.to_s
    end

    def set_uri(link)
      uri = URI.parse(link)
      url_param = Rack::Utils.parse_query(uri.query).dig("url")

      url_param ? URI.parse(url_param) : uri
    end
  end
end