module Ksl
  class ClassifiedClient

    attr_accessor :http_client, :url

    REGEX_MATCHER = /^https:\/\/www.ksl.com\/classifieds\/search/.freeze
    LISTING_URL = "https://www.ksl.com/classifieds/listing/".freeze
    RETRY_EXCEPTIONS = [
      ::HTTPClient::BadResponseError,
      ::HTTPClient::ConnectTimeoutError,
      ::HTTPClient::KeepAliveDisconnected
    ].freeze

    def initialize(search_url)
      @url = clean_url(search_url)
      @http_client = http_client
    end

    def listings
      html_page = fetch_page
      parsed_listings = parse_listings(html_page)

      build_listings(parsed_listings)
    end

    private

    def build_listings(parsed_listings)
      parsed_listings.map do |parsed_listing|
        next unless parsed_listing["id"].present?
        next if parsed_listing["listingType"] == "featured"

        ::Listing.new(
          :title => parsed_listing["title"],
          :full_description => parsed_listing["description"],
          :location => "#{parsed_listing['city']}, #{parsed_listing['state']}",
          :link => listing_url(parsed_listing["id"]),
          :price_cents => parsed_listing["price"] * 100,
          :photo_url => parsed_listing["photo"],
        )
      end.compact
    end

    def clean_url(search_url)
      url = URI.parse(search_url)
      query = clean_query(url.query)
      url.query = query

      url.to_s
    end

    def clean_query(query)
      parsed_query = Rack::Utils.parse_nested_query(query)
      parsed_query["sort"] = 0 # set sort order to newest to oldest postings
      parsed_query.to_query
    end

    def fetch_page
      response = http_client.get(url)
      response.body

    rescue *RETRY_EXCEPTIONS
      retry_count ||= 0 
      if retry_count < 1 
        ::Rails.cache.delete('current_proxy')
        retry_count += 1
        retry
      end
      raise e
    end

    def fetch_proxy
      proxy = proxy_manager.get!

      "http://#{proxy.addr}:#{proxy.port}"
    end

    def http_client
      client = ::HTTPClient.new
      client.proxy = proxy

      client
    end

    def listings_from_script_tag(script_tag)
      script_tag.gsub!(/^.*listings:/m, "")
      script_tag.gsub!(/,\n\s*spotlights:.*$/m, "")

      JSON.parse(script_tag)
    end

    def listing_url(ksl_id)
      "#{LISTING_URL}#{ksl_id}"
    end

    def parse_listings(html_listings)
      document = ::Nokogiri.parse(html_listings)

      script_tag = document.xpath("//script[contains(text(), 'window.renderSearchSection')]").text
      listings_from_script_tag(script_tag)
    end

    def proxy
      Rails.cache.fetch('current_proxy', :expires_in => 1.hour) do
        fetch_proxy
      end
    end

    def proxy_manager
      @proxy_manager ||= ::ProxyFetcher::Manager.new
    end
  end
end
