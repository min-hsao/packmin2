class WeatherService
  API_URL = "https://api.openweathermap.org/data/2.5/forecast".freeze
  GEO_URL = "https://api.openweathermap.org/geo/1.0/direct".freeze

  attr_reader :api_key

  def initialize(api_key)
    @api_key = api_key
  end

  def get_forecast(location, start_date, end_date)
    coords = geocode(location)
    return nil unless coords

    response = connection.get(API_URL) do |req|
      req.params = {
        lat: coords[:lat],
        lon: coords[:lon],
        appid: api_key,
        units: "imperial" # Fahrenheit
      }
    end

    if response.success?
      parse_forecast(response.body, start_date, end_date)
    else
      Rails.logger.error "OpenWeather API error: #{response.status} - #{response.body}"
      nil
    end
  rescue Faraday::Error => e
    Rails.logger.error "OpenWeather connection error: #{e.message}"
    nil
  end

  private

  def geocode(location)
    response = connection.get(GEO_URL) do |req|
      req.params = {
        q: location,
        limit: 1,
        appid: api_key
      }
    end

    if response.success? && response.body.is_a?(Array) && response.body.any?
      {
        lat: response.body[0]["lat"],
        lon: response.body[0]["lon"]
      }
    else
      nil
    end
  end

  def parse_forecast(data, start_date, end_date)
    return nil unless data["list"]

    start_time = Date.parse(start_date.to_s).to_time
    end_time = Date.parse(end_date.to_s).to_time + 1.day

    relevant_forecasts = data["list"].select do |item|
      time = Time.at(item["dt"])
      time >= start_time && time <= end_time
    end

    return nil if relevant_forecasts.empty?

    temps = relevant_forecasts.map { |f| f.dig("main", "temp") }.compact
    conditions = relevant_forecasts.map { |f| f.dig("weather", 0, "main") }.compact

    {
      temp_high: temps.max&.round,
      temp_low: temps.min&.round,
      temp_avg: (temps.sum / temps.size).round,
      conditions: conditions.uniq,
      rain_likely: conditions.any? { |c| c.downcase.include?("rain") },
      snow_likely: conditions.any? { |c| c.downcase.include?("snow") }
    }
  end

  def connection
    @connection ||= Faraday.new do |f|
      f.response :json
      f.request :retry, max: 2, interval: 0.5
      f.options.timeout = 30
    end
  end
end
