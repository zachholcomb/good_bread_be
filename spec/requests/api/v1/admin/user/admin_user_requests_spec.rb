require 'rails_helper'

RSpec.describe 'Admin user requests' do
  before(:each) do
    @admin = User.create(
      email: "admin@example.com",
      name: "Admin Name",
      address: "445 West St.",
      password: '1234',
      role: 2
    )
    
    @user = User.create!(
        email: 'john@example.com',
        name: 'John Wick',
        address: '900 Victoria St.',
        password: '1234',
        password_confirmation: '1234',
        role: 1
      )

    @user2 = User.create!(
      email: 'nick@example.com',
      name: 'Nick Wick',
      address: '900 Scooter St.',
      password: '1234',
      password_confirmation: '1234',
      role: 1
    )

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

  it "can see all users" do
    get '/api/v1/admin/users', headers: @header
    expect(response).to be_successful
    expect(response.status).to eq(200)

    user_response = JSON.parse(response.body, symbolize_names: true)
    expect(user_response[:data].length).to eq(2)
    expect(user_response[:data].first[:attributes][:email]).to eq(@user.email)
  end
end