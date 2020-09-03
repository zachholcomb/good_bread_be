require 'rails_helper'

RSpec.describe "User Requests" do
  describe 'perform user crud' do
    before(:each) do
      @user = User.create!(
        email: 'john@example.com',
        name: 'John Wick',
        address: '900 Victoria St.',
        password: '1234',
        password_confirmation: '1234'
      )

      @user2 = User.create!(
        email: 'nick@example.com',
        name: 'Nick Wick',
        address: '900 Scooter St.',
        password: '1234',
        password_confirmation: '1234'
      )
    end
    it 'create user specs' do
      user_params = {
        "email": "zach@example.com",
        "name": "Zach",
        "address": "594 Humboldt St",
        "password": "1234password",
        "password_confirmation": "1234password"
      }

      post '/api/v1/users', params: user_params
      expect(response).to be_successful
      expect(response.status).to eq(201)
      create_response = JSON.parse(response.body, symbolize_names: true)
      expect(create_response[:data][:attributes][:email]).to eq("zach@example.com")
    end

    it 'create user error handling missing params' do
      user_params = {
        "email": "",
        "name": "Zach",
        "address": "594 Humboldt St",
        "password": "1234password",
        "password_confirmation": "1234password"
      }
      post '/api/v1/users', params: user_params.to_json
      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      error_response = JSON.parse(response.body, symbolize_names: true)
      expect(error_response[:data][:attributes][:message]).to eq("Missing required fields")
    end

    it 'create user error handling mismatched passwords' do
      user_params = {
        "email": "zach@example.com",
        "name": "Zach",
        "address": "594 Humboldt St",
        "password": "1234password",
        "password_confirmation": "1234password"
      }
      post '/api/v1/users', params: user_params.to_json
      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      error_response = JSON.parse(response.body, symbolize_names: true)
      expect(error_response[:data][:attributes][:message]).to eq("Missing required fields")
    end

    it 'create user error handling email in use' do
      user_params = {
        "email": "zach@example.com",
        "name": "Zach",
        "address": "594 Humboldt St",
        "password": "1234password",
        "password_confirmation": "1234password"
      }
      user = User.create!(user_params)

      post '/api/v1/users', params: user_params
      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      error_response = JSON.parse(response.body, symbolize_names: true)
      expect(error_response[:data][:attributes][:message]).to eq('Email is already in use')
    end

    it 'can get a list of users' do
      get '/api/v1/users'
      expect(response).to be_successful
      expect(response.status).to eq(200)

      users_response = JSON.parse(response.body, symbolize_names: true)
      expect(users_response[:data].length).to eq(2)
      expect(users_response[:data].first[:id].to_i).to eq(@user.id)
    end

    it 'can get one user by id' do
      get "/api/v1/users/#{@user.id}"
      expect(response).to be_successful
      expect(response.status).to eq(200)

      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:data][:id].to_i).to eq(@user.id)
    end

    it 'can update a user' do
      update_params = {
        "email": "zach@google.com"
      }
      put "/api/v1/users/#{@user.id}", params: update_params
      expect(response).to be_successful
      expect(response.status).to eq(200)

      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:data][:attributes][:email]).to eq('zach@google.com')
    end

    it 'can delete a user' do
      expect(User.all.length).to eq(2)
      
      delete "/api/v1/users/#{@user.id}"
      expect(response).to be_successful
      expect(response.status).to eq(200)
      
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:data][:attributes][:id]) == @user.id
      expect(User.all.length).to eq(1)
    end
  end
end