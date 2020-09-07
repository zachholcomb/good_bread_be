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
  end

  describe "role" do
    it "should have a default role of 0" do
      user_params = {
        email: "zach@gmail.com",
        name: "Zach H",
        password: "1234",
        address: "499 Humboldt. Pl." 
      }

      user = User.create(user_params)
      expect(user.role).to eq('guest')
    end

    it "should over ride default of 0 if passed in create" do
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
end