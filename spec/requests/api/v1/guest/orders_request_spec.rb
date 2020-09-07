require 'rails_helper'

RSpec.describe 'guest orders' do
  before(:each) do
    @item_params = {"name": "Sourdough loaf", "price": 750 }
    @item_params2 = {"name": "Croissant", "price": 450 }
    @item = Item.create(@item_params)
    @item2 = Item.create(@item_params2)
  end

  it 'guest can order items' do
    
  end
end