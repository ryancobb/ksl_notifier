require 'ksl_client/base_client'

module KslClient
  class Classified < BaseClient
    RESOURCE = "classifieds".freeze
    SERVICE = "search".freeze

    def initialize(search_query)
      super(RESOURCE, SERVICE, search_query)
    end
  end
end