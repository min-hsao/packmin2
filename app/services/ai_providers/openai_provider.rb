module AiProviders
  class OpenaiProvider < BaseProvider
    API_URL = "https://api.openai.com/v1/chat/completions".freeze

    def generate_packing_list(prompt)
      response = connection.post(API_URL) do |req|
        req.headers["Authorization"] = "Bearer #{api_key}"
        req.headers["Content-Type"] = "application/json"
        req.body = {
          model: "gpt-4-turbo-preview",
          messages: [
            { role: "system", content: system_prompt },
            { role: "user", content: prompt }
          ],
          temperature: 0.7,
          max_tokens: 4000,
          response_format: { type: "json_object" }
        }.to_json
      end

      if response.success?
        content = response.body.dig("choices", 0, "message", "content")
        parse_json_response(content)
      else
        Rails.logger.error "OpenAI API error: #{response.status} - #{response.body}"
        nil
      end
    rescue Faraday::Error => e
      Rails.logger.error "OpenAI connection error: #{e.message}"
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
