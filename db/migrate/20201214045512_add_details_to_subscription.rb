class AddDetailsToSubscription < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :flavors?, :boolean
    add_column :subscriptions, :amount, :integer
  end
end
