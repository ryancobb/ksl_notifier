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
      @browser.session.visit(url)
      @browser.session.find(".ksl-header-logo")
      
      @browser.session.body
    rescue Net::ReadTimeout
      retry
    ensure
      @browser.session.try(:driver).try(:quit)
    end
    
    def html_results
      @html_results ||= fetch_results
    end
    
    def listings(html_doc)
      html_doc.css('.listing-group .listing')
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