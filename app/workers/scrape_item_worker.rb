class ScrapeItemWorker
  include Sidekiq::Worker
  sidekiq_options :queue => 'browser', :retry => false

  def perform(item_id)
    item = ::Item.find(item_id)

    item.update_listings
  end
end
