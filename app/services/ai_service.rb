class AiService
  SYSTEM_PROMPT = "You are a travel packing expert who creates efficient, comprehensive packing lists using capsule wardrobe principles."
  
  class << self
    def generate(prompt, user, provider_override = nil)
      provider_name = provider_override.presence || user.ai_provider
      provider = provider_for(provider_name)
      
      # For Google OAuth, we pass the oauth_token instead of api_key
      key = provider_name == 'google_oauth' ? user.oauth_token : user.ai_api_key
      
      provider.new(key).generate(prompt)
    end
    
    private
    
    def provider_for(name)
      case name
      when 'deepseek' then DeepSeekProvider
      when 'openai' then OpenAiProvider
      when 'gemini' then GeminiProvider
      when 'anthropic' then AnthropicProvider
      when 'google_oauth' then GoogleOAuthProvider
      else raise "Unknown AI provider: #{name}"
      end
    end
  end
  
  # Base provider class
  class BaseProvider
    def initialize(api_key)
      @api_key = api_key
    end
    
    def generate(prompt)
      raise NotImplementedError
    end
    
    protected
    
    def full_prompt(prompt)
      "#{SYSTEM_PROMPT}\n\n#{prompt}"
    end
    
    def connection
      @connection ||= Faraday.new do |f|
        f.request :json
        f.response :json
        f.request :retry, max: 2, interval: 1
        f.options.timeout = 120
      end
    end
  end
  
  # DeepSeek provider
  class DeepSeekProvider < BaseProvider
    API_URL = 'https://api.deepseek.com/v1/chat/completions'
    
    def generate(prompt)
      response = connection.post(API_URL) do |req|
        req.headers['Authorization'] = "Bearer #{@api_key}"
        req.body = {
          model: 'deepseek-chat',
          messages: [
            { role: 'system', content: SYSTEM_PROMPT },
            { role: 'user', content: prompt }
          ],
          temperature: 0.7,
          max_tokens: 4000
        }
      end
      
      raise "DeepSeek API error: #{response.status}" unless response.success?
      response.body.dig('choices', 0, 'message', 'content') || ''
    end
  end
  
  # OpenAI provider
  class OpenAiProvider < BaseProvider
    API_URL = 'https://api.openai.com/v1/chat/completions'
    
    def generate(prompt)
      response = connection.post(API_URL) do |req|
        req.headers['Authorization'] = "Bearer #{@api_key}"
        req.body = {
          model: 'gpt-4-turbo-preview',
          messages: [
            { role: 'system', content: SYSTEM_PROMPT },
            { role: 'user', content: prompt }
          ],
          temperature: 0.7,
          max_tokens: 4000
        }
      end
      
      raise "OpenAI API error: #{response.status}" unless response.success?
      response.body.dig('choices', 0, 'message', 'content') || ''
    end
  end
  
  # Gemini provider (API Key)
  class GeminiProvider < BaseProvider
    def generate(prompt)
      url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=#{@api_key}"
      
      response = connection.post(url) do |req|
        req.body = {
          contents: [{ parts: [{ text: full_prompt(prompt) }] }],
          generationConfig: { temperature: 0.7, maxOutputTokens: 4000 }
        }
      end
      
      raise "Gemini API error: #{response.status}" unless response.success?
      response.body.dig('candidates', 0, 'content', 'parts', 0, 'text') || ''
    end
  end

  # Google OAuth Provider (Uses Token)
  class GoogleOAuthProvider < BaseProvider
    def generate(prompt)
      url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent"
      
      response = connection.post(url) do |req|
        req.headers['Authorization'] = "Bearer #{@api_key}"
        req.body = {
          contents: [{ parts: [{ text: full_prompt(prompt) }] }],
          generationConfig: { temperature: 0.7, maxOutputTokens: 4000 }
        }
      end
      
      raise "Google OAuth API error: #{response.status} - #{response.body}" unless response.success?
      response.body.dig('candidates', 0, 'content', 'parts', 0, 'text') || ''
    end
  end
  
  # Anthropic Claude provider
  class AnthropicProvider < BaseProvider
    API_URL = 'https://api.anthropic.com/v1/messages'
    
    def generate(prompt)
      response = connection.post(API_URL) do |req|
        req.headers['x-api-key'] = @api_key
        req.headers['anthropic-version'] = '2023-06-01'
        req.body = {
          model: 'claude-3-sonnet-20240229',
          max_tokens: 4000,
          system: SYSTEM_PROMPT,
          messages: [{ role: 'user', content: prompt }]
        }
      end
      
      raise "Anthropic API error: #{response.status}" unless response.success?
      response.body.dig('content', 0, 'text') || ''
    end
  end
end
