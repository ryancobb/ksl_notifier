module Ksl
  class AutoClient
    attr_accessor :browser, :url

    REGEX_MATCHER = /https:\/\/www.ksl.com\/auto\/search/.freeze
    SCHEME = "https".freeze
    HOST = "www.ksl.com".freeze
    RETRY_EXCEPTIONS = [
      ::Capybara::ElementNotFound,
      ::Net::ReadTimeout
    ].freeze

    def initialize(search_url)
      @url = clean_url(search_url)
      @browser = ::Browser::Client.new
    end

    def listings
      @results ||= parse_results
    end

    private

    def clean_link(link)
      uri = URI.parse(link)

      uri.scheme = SCHEME
      uri.host = HOST
      uri.query = nil
      uri.to_s
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

    def fetch_page
      puts "Visiting: #{url}"
      browser.with_session do |session|
        session.visit(url)
        session.find(".ksl-header-logo")
      end

      browser.html
    rescue *RETRY_EXCEPTIONS
      retry_count ||= 0 
      if retry_count < 1 
        ::Rails.cache.delete('current_proxy')
        retry_count += 1
        retry
      end
      raise e
    end

    def html_results
      @html_results ||= fetch_page
    end

    def parse_results
      html_doc = Nokogiri::HTML(html_results)

      parsed_listings(html_doc).map do |listing|
        create_listing(listing)
      end
    end

    def parsed_listings(html_doc)
      html_doc.css('.listing-group .listing:not(.spotlight)')
    end
  end
end