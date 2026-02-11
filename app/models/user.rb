class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  
  # Associations
  has_many :packing_lists, dependent: :destroy
  has_many :saved_locations, dependent: :destroy
  has_many :custom_items, dependent: :destroy
  has_many :activities, dependent: :destroy
  
  # Encrypts sensitive fields
  encrypts :ai_api_key, deterministic: false
  encrypts :openweather_api_key, deterministic: false
  
  # Validations
  validates :email, presence: true, uniqueness: true
  validates :ai_provider, inclusion: { 
    in: %w[deepseek openai gemini anthropic], 
    allow_blank: true 
  }
  
  # OAuth callback
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.avatar_url = auth.info.image
    end
  end
  
  # Check if setup is complete
  def setup_complete?
    ai_provider.present? && ai_api_key.present?
  end
  
  # Get display name
  def display_name
    name.presence || email.split('@').first
  end
end
