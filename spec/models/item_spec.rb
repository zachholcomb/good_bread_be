require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
  end

  describe "relationships" do
    it { should have_many(:shipment_items) }
    it { should have_many(:shipments).through(:shipment_items) }
  end
end
