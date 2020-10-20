require 'rails_helper'
require 'fugit'

RSpec.describe ShipmentWorker, type: :worker do
  before(:each) do
    Sidekiq::Worker.clear_all

    @user = User.create!(
        email: 'john@example.com',
        name: 'John Wick',
        address: '900 Victoria St.',
        password: '1234',
        password_confirmation: '1234',
        city: "Denver",
        state: "CO",
        zip: "40000"
      )
    subscription_params = {
        subscription_type: 0,
        delivery_day: "Monday",
        user: @user
      }
    @subscription = Subscription.create!(subscription_params)

    @sidekiq_file = File.join(Rails.root, "config", "sidekiq.yml")
    @schedule = YAML.load_file(@sidekiq_file)[:schedule]
  end

  it "cron syntax is correct" do
    shipment_schedule = @schedule["add_shipment"]
    cron = shipment_schedule["every"]
    expect { Fugit.do_parse(cron) }.not_to raise_error
  end

  it "check that the worker class exists" do
    shipment_schedule = @schedule["add_shipment"]
    klass = shipment_schedule["class"]
    expect { klass.constantize }.not_to raise_error
  end

  it 'adds job to the queue' do
    expect(ShipmentWorker.jobs.size).to eq(0)

    ShipmentWorker.perform_async
    expect(ShipmentWorker.jobs.size).to eq(1)
  end

  it 'adds a shipment to the users subscription' do
    expect(@user.subscription.shipments.length).to eq(0)
    shipment_worker = ShipmentWorker.new
    shipment_worker.perform
    user = User.last
    expect(user.subscription.shipments.length).to eq(1)
  end
end