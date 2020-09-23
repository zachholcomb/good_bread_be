class UpdateShipmentForeignKey < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :shipments, :subscriptions

    add_foreign_key :shipments, :subscriptions, on_delete: :cascade
  end
end
