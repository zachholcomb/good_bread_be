require 'rails_helper'

RSpec.describe OrderItem do
  describe 'relationships' do
    it { should belong_to(:item) }
    it { should belong_to(:order) }
  end
end