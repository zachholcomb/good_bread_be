class AddTypeToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :type, :integer
    add_column :items, :description, :text
  end
end
