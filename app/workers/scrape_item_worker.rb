class ScrapeItemWorker
  include Sidekiq::Worker

  def perform(item_id)
    # Do something
  end
end
