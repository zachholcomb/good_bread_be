require 'rails_helper'

RSpec.describe Subscription do
  describe "validations" do
    it { should validate_presence_of(:delivery_day) }
    it { should validate_presence_of(:subscription_type) }
  end

  describe "relationships" do
    it { should belong_to :user }
    it { should have_many(:shipments) }
  end

  describe 'instance methods' do
    before(:each) do
      @user1 = User.create!(
        email: 'john@example.com',
        name: 'John Wick',
        address: '900 Victoria St.',
        password: '1234',
        password_confirmation: '1234'
      )
      subscription_params = {
        subscription_type: 0,
        delivery_day: "Monday",
        user: @user1
      }
      @subscription = Subscription.create!(subscription_params)
      @shipment = Shipment.create!(
        subscription: @subscription,
        delivery_date: '9/14/2020',
        status: "Delivered"
      )
      @shipment2 = Shipment.create!(
        subscription: @subscription,
        delivery_date: '9/14/2020',
        status: "Pending"
      )
    end

    it '.next_shipment' do
      expect(@subscription.next_shipment).to eq(@shipment2)
    end
  end
end