class ScrapeItemsWorker
  include Sidekiq::Worker

  def perform
    Item.find_each do |item|
      ::ScrapeItemWorker.perform_async(item.id)
    end
  end
end
