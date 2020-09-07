require 'rails_helper'

RSpec.describe 'login request' do
  before(:each) do
    @user = User.create!(
        email: 'john@example.com',
        name: 'John Wick',
        address: '900 Victoria St.',
        password: '1234',
        password_confirmation: '1234'
      )
  end

  it 'can sign a user up' do
    user_params = {
      "email": "zach@example.com",
      "name": "Zach H",
      "address": "900 East St.",
      "password": "password",
      "password_confirmation": "password"
    }
    post '/api/v1/register', params: user_params
    expect(response).to be_successful
    expect(response.status).to eq(201) 
    register_response = JSON.parse(response.body, symbolize_names: true)
    
    expect(register_response[:csrf]).to_not eq(nil)
    expect(register_response[:user][:data][:attributes][:email]).to eq("zach@example.com")
  end

  it 'cant create a user with bad credentials' do
    user_params = {
      "email": "john@example.com",
      "name": "Zach H",
      "address": "900 East St.",
      "password": "password",
      "password_confirmation": "password"
    }
    post '/api/v1/register', params: user_params
    expect(response).to_not be_successful
    expect(response.status).to eq(422)
    invalid_response = JSON.parse(response.body, symbolize_names: true)

    expect(invalid_response[:error]).to eq("Email has already been taken")
  end

  it 'user can login' do
    login_params = {
      "email": "john@example.com",
      "password": "1234"
    }

    post '/api/v1/login', params: login_params
    expect(response).to be_successful
    expect(response.status).to eq(200)

    login = JSON.parse(response.body, symbolize_names: true)
    expect(login[:csrf]).to_not eq(nil)
    expect(login[:user][:data][:attributes][:email]).to eq("john@example.com")
  end

  it 'incorrect credentials are sent unauthorized message' do
    login_params = {
      "email": "john@example.com",
      "password": "wrong_password"
    }

    post '/api/v1/login', params: login_params
    expect(response).to_not be_successful
    expect(response.status).to eq(401)

    failed_login = JSON.parse(response.body, symbolize_names: true)
    expect(failed_login[:data][:attributes][:message]).to eq("Email or password doesn't match")
  end

  it 'user can logout' do
    login_params = {
      "email": "john@example.com",
      "password": "1234"
    }

    post '/api/v1/login', params: login_params
    expect(response).to be_successful
    credentials = JSON.parse(response.body, symbolize_names: true)
    token = credentials[:csrf]

    header = {
      "X-CSRF-TOKEN": token
    }

    logout_params = {
      "email": "john@example.com",
      "password": "1234"
    }

    delete '/api/v1/logout', params: logout_params, headers: header
    expect(response).to be_successful
    expect(response.status).to eq(200)
    resp = JSON.parse(response.body, symbolize_names: true)
    expect(resp).to eq("ok")
  end
end