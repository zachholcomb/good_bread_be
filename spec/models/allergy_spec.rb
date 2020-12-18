require 'rails_helper'

RSpec.describe Allergy, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "relationships" do
    it { should have_many(:subscription_allergies) }
    it { should have_many(:subscriptions).through(:subscription_allergies) }
  end
end