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