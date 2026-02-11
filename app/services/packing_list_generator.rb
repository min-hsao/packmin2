class PackingListGenerator
  attr_reader :user, :params

  def initialize(user, params)
    @user = user
    @params = params.to_h.deep_symbolize_keys
  end

  def generate
    # Validate user has AI configured
    unless user.ai_provider.present?
      return { success: false, error: "Please configure an AI provider in settings." }
    end

    if user.requires_api_key? && user.ai_api_key.blank?
      return { success: false, error: "Please add your AI API key in settings." }
    end

    if user.cli_provider?
      return { success: false, error: "CLI providers (#{user.ai_provider}) don't work on the web. Please choose an API-based provider." }
    end

    # Build the prompt
    prompt = build_prompt

    # Get AI provider
    provider = get_ai_provider
    return { success: false, error: "AI provider not available." } unless provider

    # Generate the list
    generated_list = provider.generate_packing_list(prompt)
    
    unless generated_list
      return { success: false, error: "Failed to generate packing list. Please try again." }
    end

    # Add custom items that should always be packed
    add_custom_items(generated_list)

    # Create the packing list
    packing_list = user.packing_lists.create!(
      destinations: build_destinations,
      traveler_info: build_traveler_info,
      generated_list: generated_list,
      notes: params[:notes]
    )

    { success: true, packing_list: packing_list }
  rescue ActiveRecord::RecordInvalid => e
    { success: false, error: "Failed to save: #{e.message}" }
  rescue StandardError => e
    Rails.logger.error "PackingListGenerator error: #{e.message}\n#{e.backtrace.first(5).join("\n")}"
    { success: false, error: "An unexpected error occurred." }
  end

  def regenerate(packing_list)
    @params = {
      destinations: packing_list.destinations,
      traveler_info: packing_list.traveler_info,
      notes: packing_list.notes
    }.deep_symbolize_keys

    prompt = build_prompt
    provider = get_ai_provider
    return { success: false, error: "AI provider not available." } unless provider

    generated_list = provider.generate_packing_list(prompt)
    unless generated_list
      return { success: false, error: "Failed to regenerate. Please try again." }
    end

    add_custom_items(generated_list)
    packing_list.update!(generated_list: generated_list)

    { success: true, packing_list: packing_list }
  rescue StandardError => e
    Rails.logger.error "Regenerate error: #{e.message}"
    { success: false, error: "An unexpected error occurred." }
  end

  private

  def get_ai_provider
    case user.ai_provider
    when "deepseek"
      AiProviders::DeepseekProvider.new(user.ai_api_key)
    when "openai"
      AiProviders::OpenaiProvider.new(user.ai_api_key)
    when "gemini"
      AiProviders::GeminiProvider.new(user.ai_api_key)
    when "anthropic"
      AiProviders::AnthropicProvider.new(user.ai_api_key)
    else
      nil
    end
  end

  def build_prompt
    prompt_parts = []

    # Destinations with weather
    destinations = build_destinations
    prompt_parts << "I'm planning a trip to:"
    
    destinations.each do |dest|
      dest_info = "- #{dest['location']}"
      if dest['start_date'] && dest['end_date']
        dest_info += " from #{dest['start_date']} to #{dest['end_date']}"
        weather = get_weather(dest['location'], dest['start_date'], dest['end_date'])
        if weather
          dest_info += " (Weather: #{weather[:temp_low]}°F - #{weather[:temp_high]}°F, #{weather[:conditions].join(', ')})"
        end
      end
      prompt_parts << dest_info
    end

    # Traveler info
    traveler = build_traveler_info
    if traveler.any?
      prompt_parts << "\nTraveler:"
      prompt_parts << "- Gender: #{traveler['gender']}" if traveler['gender'].present?
      prompt_parts << "- Age: #{traveler['age']}" if traveler['age'].present?
      prompt_parts << "- Shirt size: #{traveler['shirt_size']}" if traveler['shirt_size'].present?
      prompt_parts << "- Pants size: #{traveler['pants_size']}" if traveler['pants_size'].present?
      prompt_parts << "- Shoe size: #{traveler['shoe_size']}" if traveler['shoe_size'].present?
      prompt_parts << "- Sleepwear: #{traveler['sleepwear']}" if traveler['sleepwear'].present?
    end

    # Activities
    activities = params[:activities]
    if activities.is_a?(Array) && activities.any?
      prompt_parts << "\nPlanned activities: #{activities.reject(&:blank?).join(', ')}"
    end

    # Luggage
    if params[:luggage_volume].present?
      prompt_parts << "\nLuggage capacity: #{params[:luggage_volume]} liters"
    elsif params[:luggage_name].present?
      prompt_parts << "\nLuggage: #{params[:luggage_name]} (please estimate capacity)"
    end

    # Laundry
    if params[:laundry_available]
      prompt_parts << "\nLaundry facilities available - can pack fewer clothes."
    end

    # Notes
    if params[:notes].present?
      prompt_parts << "\nAdditional notes: #{params[:notes]}"
    end

    prompt_parts << "\nPlease generate a comprehensive packing list."
    prompt_parts.join("\n")
  end

  def build_destinations
    dests = params[:destinations]
    return [] unless dests

    if dests.is_a?(Array)
      dests.map(&:to_h).map(&:stringify_keys)
    elsif dests.is_a?(Hash)
      dests.values.map(&:to_h).map(&:stringify_keys)
    else
      []
    end
  end

  def build_traveler_info
    (params[:traveler_info] || {}).to_h.stringify_keys
  end

  def get_weather(location, start_date, end_date)
    return nil unless user.openweather_api_key.present?
    
    WeatherService.new(user.openweather_api_key).get_forecast(location, start_date, end_date)
  rescue StandardError => e
    Rails.logger.error "Weather fetch failed: #{e.message}"
    nil
  end

  def add_custom_items(generated_list)
    user.custom_items.always_pack.each do |item|
      category = item.category
      generated_list[category] ||= []
      generated_list[category] << "#{item.name} (custom)"
    end
  end
end
