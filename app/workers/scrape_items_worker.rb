class ScrapeItemsWorker
  include Sidekiq::Worker

  def perform(*args)
    items = Item.all

    items.each do |item|
      ::ScrapeItemWorker.perform_async(item.id)
    end
  end
end
