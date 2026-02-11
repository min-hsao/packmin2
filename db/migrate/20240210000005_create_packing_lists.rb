class CreatePackingLists < ActiveRecord::Migration[7.1]
  def change
    create_table :packing_lists do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.jsonb :destinations, default: []
      t.jsonb :traveler_info, default: {}
      t.text :activities
      t.boolean :laundry_available, default: false
      t.decimal :luggage_volume, precision: 5, scale: 1
      t.string :luggage_name
      t.text :additional_notes
      t.jsonb :weather_data, default: {}
      t.jsonb :generated_list, default: {}
      t.text :raw_response
      t.string :status, default: 'draft'

      t.timestamps
    end
    
    add_index :packing_lists, [:user_id, :created_at]
    add_index :packing_lists, :status
  end
end
