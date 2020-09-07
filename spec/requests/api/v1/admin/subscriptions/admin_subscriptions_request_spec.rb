require 'rails_helper'

RSpec.describe 'Subscriptions requests' do
  describe 'subscriptions crud' do
    before(:each) do
      @admin = User.create(
      email: "admin@example.com",
      name: "Admin Name",
      address: "445 West St.",
      password: '1234',
      role: 2
    )

    @user1 = User.create!(
      email: 'john@example.com',
      name: 'John Wick',
      address: '900 Victoria St.',
      password: '1234',
      password_confirmation: '1234'
    )

    @user2 = User.create!(
      email: 'johnathon@example.com',
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

    login_params = {
    "email": "admin@example.com",
    "password": "1234"
    }
    post '/api/v1/login', params: login_params
    credentials = JSON.parse(response.body, symbolize_names: true)
    token = credentials[:csrf]
    @header = {
      "X-CSRF-TOKEN": token
    }
    end

    it 'get all subscriptions' do
      get "/api/v1/admin/subscriptions", headers: @header
      expect(response).to be_successful
      expect(response.status).to eq(200)

      sub_response = JSON.parse(response.body, symbolize_names: true)
      expect(sub_response[:data].length).to eq(1)
      expect(sub_response[:data].first[:attributes][:id]).to eq(@user1.subscription.id)
    end

    it 'can get subscription by id' do
      get "/api/v1/admin/subscriptions/#{@user1.subscription.id}", headers: @header
      expect(response).to be_successful
      expect(response.status).to eq(200)
      
      sub_response = JSON.parse(response.body, symbolize_names: true)
      expect(sub_response[:data][:attributes][:id]).to eq(@user1.subscription.id)
    end

    it 'has error handling if subscription not found' do
      get "/api/v1/admin/subscriptions/9999999999", headers: @header
      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      item_response = JSON.parse(response.body, symbolize_names: true)
      expect(item_response[:data][:attributes][:message]).to eq('Oops, record not found')
    end
  end
end
