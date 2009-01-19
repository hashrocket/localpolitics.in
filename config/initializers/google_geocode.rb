unless defined?(APP_CONFIG) && APP_CONFIG[:google_maps_api_key]
  warn "No Google Maps API key found. Check config/settings.yml"
end
