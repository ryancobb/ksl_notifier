class ScrapeItemsWorker
  include Sidekiq::Worker

  def perform
    items = Item.all

    items.each do |item|
      ::ScrapeItemWorker.new.perform(item.id)
    end
  end
end
