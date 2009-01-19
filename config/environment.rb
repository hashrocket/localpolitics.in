RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Specify gems that this application depends on. 
  # They can then be installed with "rake gems:install" on new installations.
  # You have to specify the :lib option for libraries, where the Gem name (sqlite3-ruby) differs from the file itself (sqlite3)
  config.gem "ym4r", :version => ">= 0.6.1"
  config.gem "json", :version => ">= 1.1.3"

  config.time_zone = 'UTC'

  config.action_controller.session = {
    :session_key => '_localpolitics.in_session',
    :secret      => '43f098bc82f9c8b2cffab59913f4fae6e1d28d2792f2971b987c8ca93a9c1e03b3d688346d16192a56e0f02314c2c9876f4de6a66f30d1e10f9b8a3231e7a48e'
  }
end

require 'sunlight'
