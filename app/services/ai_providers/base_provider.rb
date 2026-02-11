module AiProviders
  class BaseProvider
    attr_reader :api_key

    def initialize(api_key)
      @api_key = api_key
    end

    def generate_packing_list(prompt)
      raise NotImplementedError, "Subclass must implement #generate_packing_list"
    end

    protected

    def parse_json_response(text)
      # Try to extract JSON from the response
      json_match = text.match(/\{[\s\S]*\}/)
      return nil unless json_match

      JSON.parse(json_match[0])
    rescue JSON::ParserError => e
      Rails.logger.error "Failed to parse AI response: #{e.message}"
      nil
    end

    def connection
      @connection ||= Faraday.new do |f|
        f.request :json
        f.response :json
        f.request :retry, max: 2, interval: 0.5
        f.options.timeout = 60
        f.options.open_timeout = 10
      end
    end
  end
end
