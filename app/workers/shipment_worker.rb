class ShipmentWorker
  include Sidekiq::Worker

  def perform(*args)
    five_days_later = 432000
    delivery_date = Time.now + five_days_later
    
    User.users_with_subscriptions.each do |user|
      user.subscription.shipments.create(
        status: 0,
        delivery_date: delivery_date.strftime('%m/%d/%y')
      )
    end
  end
end
