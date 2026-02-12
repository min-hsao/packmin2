class PackingListGenerator
  def initialize(packing_list)
    @packing_list = packing_list
    @user = packing_list.user
  end
  
  def generate
    # Determine provider
    provider = @packing_list.ai_provider.presence || @user.ai_provider
    
    # Skip weather for smart providers if requested
    smart_providers = ['google_oauth', 'gemini', 'anthropic']
    skip_weather = smart_providers.include?(provider)
    
    # Fetch weather for all destinations
    weather_data = skip_weather ? {} : fetch_weather
    @packing_list.update(weather_data: weather_data)
    
    # Build prompt
    prompt = build_prompt(weather_data, skip_weather)
    
    # Generate with AI
    raw_response = AiService.generate(prompt, @user, provider)
    
    # Parse response
    parsed = parse_response(raw_response)
    
    # Update packing list
    @packing_list.update(
      raw_response: raw_response,
      generated_list: parsed,
      status: 'complete'
    )
    
    @packing_list
  rescue => e
    Rails.logger.error "Packing list generation failed: #{e.message}"
    @packing_list.update(
      status: 'error',
      raw_response: "Error: #{e.message}"
    )
    raise
  end
  
  private
  
  def fetch_weather
    return {} unless @user.openweather_api_key.present?
    
    service = WeatherService.new(@user.openweather_api_key)
    weather = {}
    
    @packing_list.destinations.each do |dest|
      location = dest['location']
      start_date = Date.parse(dest['start_date']) rescue Date.today
      end_date = Date.parse(dest['end_date']) rescue start_date + 7
      
      weather[location] = service.get_weather(location, start_date, end_date)
    end
    
    weather
  end
  
  def build_prompt(weather_data, weather_skipped = false)
    traveler = @packing_list.traveler_info || {}
    destinations = @packing_list.destinations || []
    
    weather_section = if weather_skipped
      "Please estimate the typical weather for these locations and dates, or use your knowledge/tools to find the forecast."
    else
      weather_data.map { |loc, w| "- #{loc}: High #{w[:high_f]}°F, Low #{w[:low_f]}°F, #{w[:conditions]}" }.join("\n")
    end
    
    prompt = <<~PROMPT
      Create a comprehensive packing list for the following trip:

      ## Trip Details
      #{destinations.map { |d| "- #{d['location']}: #{d['start_date']} to #{d['end_date']}" }.join("\n")}
      Total duration: #{@packing_list.total_days} days

      ## Weather Conditions
      #{weather_section}

      ## Traveler
      - Gender: #{traveler['gender'] || 'Not specified'}
      - Age: #{traveler['age'] || 'Not specified'}
      - Clothing size: #{traveler['clothing_size'] || 'Not specified'}
      - Shoe size: #{traveler['shoe_size'] || 'Not specified'}
      - Sleepwear: #{traveler['sleepwear'] || 'minimal'}

      ## Trip Info
      - Activities: #{@packing_list.activities.presence || 'General travel'}
      - Laundry available: #{@packing_list.laundry_available ? 'Yes' : 'No'}
      - Luggage capacity: #{@packing_list.luggage_volume || 40}L #{@packing_list.luggage_name.presence ? "(#{@packing_list.luggage_name})" : ''}
      #{@packing_list.additional_notes.present? ? "- Notes: #{@packing_list.additional_notes}" : ''}

      ## Instructions
      Create an efficient capsule wardrobe packing list that:
      1. Maximizes mix-and-match versatility
      2. Accounts for weather conditions
      3. Fits within luggage capacity
      4. Considers laundry availability

      Format the response as a structured list with:
      - Category (clothing, toiletries, electronics, documents, etc.)
      - Item name
      - Quantity
      - Notes (optional)

      Include:
      - What to wear on departure (not packed)
      - What to pack in luggage
      - Estimated total volume and weight
    PROMPT
    
    prompt
  end
  
  def parse_response(raw_response)
    # Try to extract structured data
    # For now, just return the raw response in a structured format
    {
      raw: raw_response,
      generated_at: Time.current.iso8601
    }
  end
end
