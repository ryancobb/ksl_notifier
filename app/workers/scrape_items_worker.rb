class ScrapeItemsWorker
  include Sidekiq::Worker

  def perform
    Item.find_each do |item|
      ::ScrapeItemWorker.new.perform(item.id)
    end
  end
end
