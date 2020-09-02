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
end