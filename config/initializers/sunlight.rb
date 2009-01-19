require 'sunlight'
if defined?(APP_CONFIG) && key = APP_CONFIG[:sunlight_api_key]
  include Sunlight
  Sunlight.api_key = key
else
  warn "No Sunlight API key found. Check config/settings.yml"
end
