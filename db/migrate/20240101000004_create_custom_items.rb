class CreateCustomItems < ActiveRecord::Migration[7.1]
  def change
    create_table :custom_items do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :category, null: false
      t.decimal :volume_liters, precision: 6, scale: 2
      t.boolean :always_pack, default: false, null: false

      t.timestamps
    end

    add_index :custom_items, [:user_id, :category]
    add_index :custom_items, [:user_id, :always_pack]
  end
end
