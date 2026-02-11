module AiProviders
  class GeminiProvider < BaseProvider
    API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent".freeze

    def generate_packing_list(prompt)
      url = "#{API_URL}?key=#{api_key}"
      
      response = connection.post(url) do |req|
        req.headers["Content-Type"] = "application/json"
        req.body = {
          contents: [
            {
              parts: [
                { text: "#{system_prompt}\n\nUser request: #{prompt}" }
              ]
            }
          ],
          generationConfig: {
            temperature: 0.7,
            maxOutputTokens: 4000
          }
        }.to_json
      end

      if response.success?
        content = response.body.dig("candidates", 0, "content", "parts", 0, "text")
        parse_json_response(content)
      else
        Rails.logger.error "Gemini API error: #{response.status} - #{response.body}"
        nil
      end
    rescue Faraday::Error => e
      Rails.logger.error "Gemini connection error: #{e.message}"
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
