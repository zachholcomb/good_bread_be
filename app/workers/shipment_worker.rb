class ShipmentWorker
  include Sidekiq::Worker

  def perform(*args)
    p User.all
  end
end
