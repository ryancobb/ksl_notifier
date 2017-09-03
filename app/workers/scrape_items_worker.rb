class ScrapeItemsWorker
  include Sidekiq::Worker

  def perform(*args)
    ::ScrapeItemWorker.perform_async(1)
  end
end
