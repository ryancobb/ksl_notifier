module KslClient
  class Auto < ::KslClient::BaseClient
    RESOURCE = "auto/search".freeze
    SERVICE = "index".freeze

    def initialize(search_query)
      super(RESOURCE, SERVICE, search_query)
    end
  end
end