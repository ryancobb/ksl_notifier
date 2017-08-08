class Item < ApplicationRecord
  has_many :listings

  scope :by_user, -> (user) { where(:user_id => user.id) }

  def get_listings
    client = infer_client
    client = client.new(query_params)
    listings = client.results

    byebug

  end

  private

  def infer_client
    case search_url
    when ::KslClient::Auto.regex_matcher
      ::KslClient::Auto
    when ::KslClient::Classified.regex_matcher
      ::KslClient::Classified
    end
  end

  def parse_query_params
    CGI.parse(URI.parse(search_url).query)
  end

  def query_params
    parse_query_params
  end
end
