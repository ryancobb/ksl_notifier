module KslClient
  class BaseClient
    BASE_URL = Rails.configuration.ksl["url"].freeze

    def initialize(resource, service, query_params)
      @resource = resource
      @service = service
      @query_params = query_params
      @browser = ::Browser::Client.new
    end

    def self.regex_matcher
      /#{::KslClient::BaseClient::BASE_URL}\/#{self::RESOURCE}\/#{self::SERVICE}/
    end

    private
    
    def html_results
      @html_results ||= fetch_results
    end

    def parse_results
      html_doc = Nokogiri::HTML(html_results)

      listings(html_doc).map do |listing|
        create_listing(listing)
      end
    end

    def fetch_results
      puts "Visiting: #{url}"
      @browser.session.visit(url)
      @browser.session.find(".ksl-header-logo")
      
      @browser.session.body
    ensure
      @browser.session.driver.quit
    end

    def listings(html_doc)
      html_doc.css('.listing-group .listing')
    end

    def url
      "#{BASE_URL}/#{@resource}/#{@service}?#{@query_params}"
    end
  end
end