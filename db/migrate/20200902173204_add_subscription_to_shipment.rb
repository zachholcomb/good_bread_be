class AddSubscriptionToShipment < ActiveRecord::Migration[5.2]
  def change
    add_reference :shipments, :subscription, foreign_key: true
  end
end
