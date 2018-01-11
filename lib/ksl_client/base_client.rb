module KslClient
  module BaseClient
    extend ActiveSupport::Concern
    
    BASE_URL = Rails.configuration.ksl["url"].freeze
    
    module ClassMethods
      def regex_matcher
        /#{BASE_URL}\/#{self::RESOURCE}\/#{self::SERVICE}/
      end
    end

    def results
      @results ||= parse_results
    end

    private

    def clean_link(link)
      uri = set_uri(link)

      uri.query = nil
      BASE_URL + uri.path
    end

    def fetch_results
      puts "Visiting: #{url}"
      @browser.visit(url)
      @browser.find(".ksl-header-logo")
      
      @browser.body
    rescue ::Net::ReadTimeout => e
      attempts ||= 0
      if attempts < 1
        attempts += 1
        @browser.driver.quit
        retry
      end
      
      raise e
    end
    
    def html_results
      @html_results ||= fetch_results
    end

    def parse_results
      html_doc = Nokogiri::HTML(html_results)

      listings(html_doc).map do |listing|
        create_listing(listing)
      end
    end

    def set_uri(link)
      uri = URI.parse(link)
      url_param = Rack::Utils.parse_query(uri.query).dig("url")

      url_param ? URI.parse(url_param) : uri
    end

    def url
      "#{BASE_URL}/#{self.class::RESOURCE}/#{self.class::SERVICE}?#{@query_params}"
    end

  end
end