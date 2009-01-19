= google-geocode

Rubyforge Project:

http://rubyforge.org/projects/rctools

Documentation:

http://dev.robotcoop.com/Libraries/google-geocode

== About

google-geocode implements Google's Geocoding API.

== Installing google-geocode

Just install the gem:

  $ sudo gem install google-geocode

== Using google-geocode

First you need a Google Maps API key.  You can register for one here:

http://www.google.com/apis/maps/signup.html

Then you create a GoogleGeocode object and start locating addresses:

  require 'rubygems'
  require 'google_geocode'
  
  gg = GoogleGeocode.new application_id
  location = gg.locate '1600 Amphitheater Pkwy, Mountain View, CA'
  p location.coordinates

