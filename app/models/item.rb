class Item < ApplicationRecord
  has_many :listings, :dependent => :destroy
  has_many :notifications, :dependent => :destroy

  scope :by_user, -> (user) { where(:user_id => user.id) }

  def update_listings
    new_listings = get_listings
    new_listings_links = new_listings.map(&:link)
    existing_listings = listings.where(:link => new_listings_links, :item_id => id)

    new_listings.reject! do |new_listing|
      existing_listings.any? do |existing_listing|
        existing_listing.link == new_listing.link
      end
    end

    new_listings.each do |new_listing|
      new_listing.item_id = id
      new_listing.save
    end
  end

  private

  def get_listings
    client = infer_client
    client = client.new(query_params)
    client.results
  end

  def infer_client
    case search_url
    when ::KslClient::Auto.regex_matcher
      ::KslClient::Auto
    when ::KslClient::Classified.regex_matcher
      ::KslClient::Classified
    else
      raise "Unsupported URL: #{search_url}"
    end
  end

  def parse_query_params
    Rack::Utils.parse_nested_query(URI.parse(search_url).query)
  end

  def query_params
    parsed_params = parse_query_params
    parsed_params["sort"] = 0 # set sort order to newest to oldest postings
    parsed_params.to_query
  end
end
