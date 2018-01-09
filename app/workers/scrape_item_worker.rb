class ScrapeItemWorker
  include Sidekiq::Worker
  sidekiq_options :queue => 'browser'

  def perform(item_id)
    item = ::Item.find(item_id)

    item.update_listings
  end
end
