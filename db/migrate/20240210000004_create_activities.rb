class CreateActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :activities do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.text :default_items # JSON array of item names

      t.timestamps
    end
    
    add_index :activities, [:user_id, :name], unique: true
  end
end
