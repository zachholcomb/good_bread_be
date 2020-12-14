class CreateTableSubscriptionAllergies < ActiveRecord::Migration[5.2]
  def change
    create_table :subscription_allergies do |t|
      t.references :allergy, foreign_key: true
      t.references :subscription, foreign_key: true    end
  end
end
