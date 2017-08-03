module KslClient
  class BaseClient
    def initialize(resource, service, query_params)
      @resource = resource
      @service = service
      @query_params = query_params
      @base_url = Rails.configuration.ksl["url"]
      @browser = ::Browser::Client.new
    end

    def html_results
      @html_results ||= fetch_results
    end

    private

    def parse_results
      html_doc = Nokogiri::HTML(html_results)

      listings(html_doc).map do |listing|
        create_listing(listing)
      end
    end

    def fetch_results
      puts "Visiting: #{url}"
      @browser.visit(url)
      @browser.page.body
    end

    def listings(html_doc)
      html_doc.css('.listing-group .listing')
    end

    def url
      "#{@base_url}/#{@resource}/#{@service}?#{@query_params.to_query}"
    end
  end
end