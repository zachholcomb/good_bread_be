require 'rails_helper'

RSpec.describe Order do
  describe 'validations' do
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:delivery_date) }
  end

  describe 'relationships' do
    it { should have_many(:order_items) }
    it { should have_many(:items).through(:order_items) }
    it { should belong_to(:user) }
  end
end