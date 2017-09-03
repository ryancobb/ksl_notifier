class Item < ApplicationRecord
  has_many :listings

  scope :by_user, -> (user) { where(:user_id => user.id) }

  def update_listings
    new_listings = get_listings
    
    new_listings.each do |new_listing|
      old_listing = listings.find_by_link(new_listing.link)

      if old_listing
        new_listing_attributes = new_listing.attributes.reject do |k,v|
          ["id", "created_at", "updated_at", "item_id"].include?(k)
        end
        old_listing.assign_attributes(new_listing_attributes)
        old_listing.save if old_listing.changed?
      else
        new_listing.item_id = id
        new_listing.save
      end
    end
  end

  private

  def get_listings
    client = infer_client
    client = client.new(query_params)
    listings = client.results
  end

  def infer_client
    case search_url
    when ::KslClient::Auto.regex_matcher
      ::KslClient::Auto
    when ::KslClient::Classified.regex_matcher
      ::KslClient::Classified
    end
  end

  def parse_query_params
    URI.parse(search_url).query
  end

  def query_params
    parse_query_params
  end
end
