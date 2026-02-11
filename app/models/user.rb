class User < ApplicationRecord
  # Encrypted attributes for API keys
  encrypts :ai_api_key, deterministic: false
  encrypts :openweather_api_key, deterministic: false

  # Associations
  has_many :packing_lists, dependent: :destroy
  has_many :saved_locations, dependent: :destroy
  has_many :custom_items, dependent: :destroy
  has_many :activities, dependent: :destroy

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :uid, presence: true
  validates :provider, presence: true

  # Available AI providers
  AI_PROVIDERS = {
    "deepseek" => { name: "DeepSeek", requires_key: true, description: "DeepSeek AI - Fast and affordable" },
    "openai" => { name: "OpenAI", requires_key: true, description: "GPT-4 and GPT-3.5 models" },
    "gemini" => { name: "Google Gemini", requires_key: true, description: "Google's Gemini Pro" },
    "anthropic" => { name: "Anthropic", requires_key: true, description: "Claude models" },
    "gemini-cli" => { name: "Gemini CLI", requires_key: false, description: "⚠️ CLI only - won't work on server" },
    "claude-cli" => { name: "Claude CLI", requires_key: false, description: "⚠️ CLI only - won't work on server" }
  }.freeze

  def self.find_or_create_from_oauth(auth)
    user = find_by(provider: auth.provider, uid: auth.uid)

    if user
      user.update(
        email: auth.info.email,
        name: auth.info.name,
        avatar_url: auth.info.image
      )
    else
      user = create!(
        provider: auth.provider,
        uid: auth.uid,
        email: auth.info.email,
        name: auth.info.name,
        avatar_url: auth.info.image,
        setup_completed: false
      )
    end

    user
  end

  def requires_api_key?
    return false unless ai_provider.present?
    AI_PROVIDERS.dig(ai_provider, :requires_key) || false
  end

  def cli_provider?
    %w[gemini-cli claude-cli].include?(ai_provider)
  end

  def display_name
    name.presence || email.split("@").first
  end
end
