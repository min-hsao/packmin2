class DeviseCreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      # Devise fields
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      
      # OAuth fields
      t.string :provider
      t.string :uid
      
      # Profile fields
      t.string :name
      t.string :avatar_url
      
      # AI Configuration
      t.string :ai_provider
      t.text :ai_api_key
      t.text :openweather_api_key
      
      # Setup status
      t.boolean :setup_completed, default: false
      
      # Traveler defaults
      t.string :default_gender
      t.integer :default_age
      t.string :default_clothing_size
      t.string :default_shoe_size
      t.string :default_sleepwear, default: 'minimal'

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, [:provider, :uid], unique: true
  end
end
