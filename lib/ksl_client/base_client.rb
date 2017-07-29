module KslClient
  class BaseClient
    include HTTParty
    base_uri Rails.configuration.ksl["url"]

    def initialize(resource, service, search_query)
      @options = { :query => search_query }
      @resource = resource
      @service = service
    end

    def get_results
      self.class.get("/#{@resource}/#{@service}", @options)
    end
  end
end