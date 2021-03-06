class Item < ApplicationRecord
  has_many :listings, :dependent => :destroy
  has_many :notifications, :dependent => :destroy

  scope :by_user, -> (user) { where(:user_id => user.id) }

  validates :name, :presence => true
  validate :valid_url, :supported_url, :has_query_params

  SUPPORTED_URLS = [::Ksl::AutoClient::REGEX_MATCHER, ::Ksl::ClassifiedClient::REGEX_MATCHER].freeze

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
    client = client.new(search_url)
    client.listings
  end

  def has_query_params
    query_params = parsed_query_params
    query_params.reject! { |k,_v| k == "sort"}
    return if query_params.present?

    errors.add(:search_url, "Doesn't look like your URL is searching for anything...")
  end

  def infer_client
    case search_url
    when ::Ksl::AutoClient::REGEX_MATCHER
      ::Ksl::AutoClient
    when ::Ksl::ClassifiedClient::REGEX_MATCHER
      ::Ksl::ClassifiedClient
    else
      raise "Unsupported URL: #{search_url}"
    end
  end

  def parsed_query_params
    Rack::Utils.parse_nested_query(URI.parse(search_url).query)
  rescue ::URI::InvalidURIError
    {}
  end

  def supported_url
    return if SUPPORTED_URLS.any? { |supported_url| supported_url =~ search_url }
    errors.add(:search_url, "We don't support notifications from this site yet.")
  end

  def valid_url
    return if search_url =~ URI.regexp
    errors.add(:search_url, "Invalid URL. Make sure you type in a fully qualified URL.")
  end
end
