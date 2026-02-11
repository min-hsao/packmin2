class WeatherService
  BASE_URL = 'https://api.openweathermap.org/data/2.5'
  
  def initialize(api_key)
    @api_key = api_key
  end
  
  def get_weather(location, start_date, end_date)
    coords = geocode(location)
    return seasonal_estimate(location, start_date) unless coords
    
    # OpenWeather free tier only gives 5-day forecast
    # For dates beyond that, use seasonal estimates
    days_from_now = (start_date - Date.today).to_i
    
    if days_from_now <= 5 && days_from_now >= 0
      forecast_weather(coords, start_date, end_date)
    else
      seasonal_estimate(location, start_date)
    end
  rescue => e
    Rails.logger.error "Weather API error: #{e.message}"
    seasonal_estimate(location, start_date)
  end
  
  private
  
  def connection
    @connection ||= Faraday.new(url: BASE_URL) do |f|
      f.response :json
      f.request :retry, max: 2
      f.options.timeout = 10
    end
  end
  
  def geocode(location)
    response = Faraday.get('https://api.openweathermap.org/geo/1.0/direct') do |req|
      req.params = { q: location, limit: 1, appid: @api_key }
    end
    
    return nil unless response.success?
    
    data = JSON.parse(response.body)
    return nil if data.empty?
    
    { lat: data[0]['lat'], lon: data[0]['lon'] }
  end
  
  def forecast_weather(coords, start_date, end_date)
    response = connection.get('forecast') do |req|
      req.params = {
        lat: coords[:lat],
        lon: coords[:lon],
        appid: @api_key,
        units: 'imperial'
      }
    end
    
    return seasonal_estimate('', start_date) unless response.success?
    
    forecasts = response.body['list'] || []
    
    # Average temps from forecast
    temps = forecasts.map { |f| f.dig('main', 'temp') }.compact
    conditions = forecasts.map { |f| f.dig('weather', 0, 'main') }.compact
    
    {
      high_f: temps.max&.round || 70,
      low_f: temps.min&.round || 50,
      conditions: conditions.uniq.first(3).join(', '),
      is_forecast: true
    }
  end
  
  def seasonal_estimate(location, date)
    month = date.month
    
    # Very rough seasonal estimates for US locations
    season = case month
             when 12, 1, 2 then :winter
             when 3, 4, 5 then :spring
             when 6, 7, 8 then :summer
             else :fall
             end
    
    temps = {
      winter: { high: 45, low: 30 },
      spring: { high: 65, low: 45 },
      summer: { high: 85, low: 65 },
      fall: { high: 60, low: 40 }
    }
    
    {
      high_f: temps[season][:high],
      low_f: temps[season][:low],
      conditions: 'Seasonal estimate',
      is_forecast: false
    }
  end
end
