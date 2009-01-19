if defined?(SETTINGS) && key = SETTINGS[:sunlight_api_key]
  Sunlight.api_key = key
else
  warn "No Sunlight API key found. Check config/settings.yml"
end
