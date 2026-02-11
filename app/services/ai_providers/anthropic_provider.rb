module AiProviders
  class AnthropicProvider < BaseProvider
    API_URL = "https://api.anthropic.com/v1/messages".freeze

    def generate_packing_list(prompt)
      response = connection.post(API_URL) do |req|
        req.headers["x-api-key"] = api_key
        req.headers["anthropic-version"] = "2023-06-01"
        req.headers["Content-Type"] = "application/json"
        req.body = {
          model: "claude-3-sonnet-20240229",
          max_tokens: 4000,
          system: system_prompt,
          messages: [
            { role: "user", content: prompt }
          ]
        }.to_json
      end

      if response.success?
        content = response.body.dig("content", 0, "text")
        parse_json_response(content)
      else
        Rails.logger.error "Anthropic API error: #{response.status} - #{response.body}"
        nil
      end
    rescue Faraday::Error => e
      Rails.logger.error "Anthropic connection error: #{e.message}"
      nil
    end

    private

    def system_prompt
      <<~PROMPT
        You are an expert travel packing assistant. Generate comprehensive, practical packing lists.
        Always respond with valid JSON in this exact format:
        {
          "clothing": ["item1", "item2"],
          "toiletries": ["item1", "item2"],
          "electronics": ["item1", "item2"],
          "documents": ["item1", "item2"],
          "accessories": ["item1", "item2"],
          "miscellaneous": ["item1", "item2"]
        }
        Consider weather, activities, trip duration, and traveler preferences.
        Be specific with quantities (e.g., "5 pairs of underwear" not just "underwear").
      PROMPT
    end
  end
end
