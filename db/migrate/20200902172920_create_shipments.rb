class CreateShipments < ActiveRecord::Migration[5.2]
  def change
    create_table :shipments do |t|
      t.integer :status
      t.string :delivery_date

      t.timestamps
    end
  end
end
