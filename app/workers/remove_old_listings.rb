class RemoveOldListings
  include Sidekiq::Worker

  def perform
    listings_to_destroy = ::Listing.where('created_at < ?', 1.day.ago).select(:id)

    listings_to_destroy.find_in_batches do |batch|
      ids = batch.map(&:id)

      ::Listing.where(:id => ids).destroy_all
    end
  end
end
