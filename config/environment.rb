RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')

config_file_path = File.join(RAILS_ROOT, *%w(config settings.yml))
if File.exist?(config_file_path)
  config = YAML.load_file(config_file_path)
  APP_CONFIG = config.has_key?(RAILS_ENV) ? config[RAILS_ENV] : {}
else
  puts "WARNING: configuration file #{config_file_path} not found."
  APP_CONFIG = {}
end

Rails::Initializer.run do |config|
  config.gem "google-geocode", :lib => "google_geocode", :version => "1.2.1"
  config.gem "httparty", :version => ">= 0.2.6"
  config.gem "json", :version => ">= 1.1.3"
  config.gem "thoughtbot-factory_girl", :lib => "factory_girl", :version => ">= 1.1.5"
  config.gem "ym4r", :version => ">= 0.6.1"

  # gems used for testing don't need to be loaded, so they have the key :lib => false
  config.gem 'chrisk-fakeweb', :lib => false, :version => '>= 1.1.2.7', :source => 'http://gems.github.com'
  config.gem "mocha", :lib => false, :version => ">= 0.9.4"
  config.gem "nokogiri", :lib => false, :version => ">= 1.1.1"
  config.gem 'rspec-rails', :lib => false, :version => '>= 1.2.1'

  config.time_zone = 'UTC'

  # FIXME:  secret key must be moved to settings file to avoid exposure
  config.action_controller.session = {
    :session_key => '_localpolitics.in_session',
    :secret      => '43f098bc82f9c8b2cffab59913f4fae6e1d28d2792f2971b987c8ca93a9c1e03b3d688346d16192a56e0f02314c2c9876f4de6a66f30d1e10f9b8a3231e7a48e'
  }
end

