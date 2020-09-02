class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.string :delivery_day
      t.integer :subscription_type

      t.timestamps
    end
  end
end
