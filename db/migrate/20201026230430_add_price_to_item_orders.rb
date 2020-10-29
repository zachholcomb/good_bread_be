class AddPriceToItemOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :order_items, :price, :integer
  end
end
