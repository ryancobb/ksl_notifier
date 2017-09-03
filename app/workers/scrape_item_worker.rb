class ScrapeItemWorker
  include Sidekiq::Worker

  def perform(item_id)
    item = ::Item.find(item_id)

    item.update_listings
  end
end
