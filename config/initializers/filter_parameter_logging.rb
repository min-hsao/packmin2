# Be sure to restart your server when you modify this file.

# Configure parameters to be partially matched and filtered from the log file.
Rails.application.config.filter_parameters += [
  :passw, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssn,
  :api_key, :ai_api_key, :openweather_api_key
]
