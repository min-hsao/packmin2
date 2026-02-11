class CreateSavedLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :saved_locations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :address, null: false
      t.text :default_activities
      t.boolean :favorite, default: false

      t.timestamps
    end
    
    add_index :saved_locations, [:user_id, :name], unique: true
  end
end
