require 'rails_helper'

RSpec.describe Shipment do
  describe "validations" do
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:delivery_date) }
  end

  describe "relationships" do
    it { should belong_to(:subscription) }
    it { should have_many(:shipment_items) }
    it { should have_many(:items).through(:shipment_items) }
  end
end