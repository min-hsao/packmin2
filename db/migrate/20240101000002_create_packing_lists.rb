class CreatePackingLists < ActiveRecord::Migration[7.1]
  def change
    create_table :packing_lists do |t|
      t.references :user, null: false, foreign_key: true
      t.text :destinations, null: false
      t.text :traveler_info, null: false
      t.text :generated_list
      t.text :notes

      t.timestamps
    end

    add_index :packing_lists, [:user_id, :created_at]
  end
end
