require 'rails_helper'

RSpec.describe User do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password_digest) }
    it { should validate_presence_of(:address) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:role) }
  end

  describe "relationships" do
    it { should have_one :subscription }
    it { should have_many :orders }
  end

  describe "role" do
    it "should have a default role of 1" do
      user_params = {
        email: "zach@gmail.com",
        name: "Zach H",
        password: "1234",
        address: "499 Humboldt. Pl." 
      }

      user = User.create(user_params)
      expect(user.role).to eq('user')
    end

    it "should over ride default of 1 if passed in create" do
      user_params = {
        email: "zach@gmail.com",
        name: "Zach H",
        password: "1234",
        address: "499 Humboldt St.",
        role: 1
      }

      user = User.create(user_params)
      expect(user.role).to eq('user')

      admin_params = {
        email: "ollie@gmail.com",
        name: "Zach H",
        password: "1234",
        address: "499 Humboldt. Pl.",
        role: 2
      }

      admin = User.create(admin_params)
      expect(admin.role).to eq('admin')
    end
  end

  describe "class methods" do
    before(:each) do
      user_params = {
        email: "zach@gmail.com",
        name: "Zach H",
        password: "1234",
        address: "499 Humboldt. Pl." 
      }

      @user = User.create(user_params)

      @user2 = User.create!(
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
          user: @user2
        }
      @subscription = Subscription.create!(subscription_params)
    end

    it ".users_with_subscriptions" do
      expect(User.users_with_subscriptions).to eq([@user2])
    end
  end
end