class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :name
      t.string :avatar_url
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :ai_provider
      t.text :ai_api_key
      t.text :openweather_api_key
      t.boolean :setup_completed, default: false, null: false

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, [:provider, :uid], unique: true
  end
end
