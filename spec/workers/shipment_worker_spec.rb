require 'rails_helper'
RSpec.describe ShipmentWorker, type: :worker do
  before(:each) do
    Sidekiq::Worker.clear_all

    @user = User.create!(
        email: 'john@example.com',
        name: 'John Wick',
        address: '900 Victoria St.',
        password: '1234',
        password_confirmation: '1234'
      )
    subscription_params = {
        subscription_type: 0,
        delivery_day: "Monday",
        user: @user
      }
    @subscription = Subscription.create!(subscription_params)
  end

  it 'adds job to the queue' do
    expect(ShipmentWorker.jobs.size).to eq(0)

    ShipmentWorker.perform_async(@user)
    expect(ShipmentWorker.jobs.size).to eq(1)
  end

  it 'adds a shipment to the users subscription' do
    ShipmentWorker.perform_async(@user)
    
  end
end