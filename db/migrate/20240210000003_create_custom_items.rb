class CreateCustomItems < ActiveRecord::Migration[7.1]
  def change
    create_table :custom_items do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :category
      t.decimal :volume_liters, precision: 5, scale: 2
      t.boolean :always_pack, default: false
      t.text :notes

      t.timestamps
    end
    
    add_index :custom_items, [:user_id, :name], unique: true
    add_index :custom_items, [:user_id, :category]
  end
end
