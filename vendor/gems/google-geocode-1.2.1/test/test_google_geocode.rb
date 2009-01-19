require 'test/unit'

require 'rubygems'
require 'rc_rest/uri_stub'

require 'google_geocode'

class TestGoogleGeocode < Test::Unit::TestCase

  def setup
    URI::HTTP.responses = []
    URI::HTTP.uris = []

    @gg = GoogleGeocode.new 'APP_ID'
  end

  def test_locate
    URI::HTTP.responses << <<-EOF.strip
<?xml version="1.0" encoding="UTF-8"?><kml xmlns="http://earth.google.com/kml/2.0"><Response><name>1600 Amphitheatre Parkway, Mountain View, CA</name><Status><code>200</code><request>geocode</request></Status><Placemark><address>1600 Amphitheatre Pkwy, Mountain View, CA 94043, USA</address><AddressDetails xmlns="urn:oasis:names:tc:ciq:xsdschema:xAL:2.0"><Country><CountryNameCode>US</CountryNameCode><AdministrativeArea><AdministrativeAreaName>CA</AdministrativeAreaName><SubAdministrativeArea><SubAdministrativeAreaName>Santa Clara</SubAdministrativeAreaName><Locality><LocalityName>Mountain View</LocalityName><Thoroughfare><ThoroughfareName>1600 Amphitheatre Pkwy</ThoroughfareName></Thoroughfare><PostalCode><PostalCodeNumber>94043</PostalCodeNumber></PostalCode></Locality></SubAdministrativeArea></AdministrativeArea></Country></AddressDetails><Point><coordinates>-122.083739,37.423021,0</coordinates></Point></Placemark></Response></kml>
    EOF

    location = GoogleGeocode::Location.new
    location.address = '1600 Amphitheatre Pkwy, Mountain View, CA 94043, USA'
    location.latitude = 37.423021
    location.longitude = -122.083739

    assert_equal location,
                 @gg.locate('1600 Amphitheatre Parkway, Mountain View, CA')

    assert_equal true, URI::HTTP.responses.empty?
    assert_equal 1, URI::HTTP.uris.length
    assert_equal 'http://maps.google.com/maps/geo?key=APP_ID&output=xml&q=1600%20Amphitheatre%20Parkway,%20Mountain%20View,%20CA',
                 URI::HTTP.uris.first
  end

  def test_locate_bad_key
    URI::HTTP.responses << <<-EOF.strip
<?xml version='1.0' encoding='UTF-8'?><kml xmlns='http://earth.google.com/kml/2.0'><Response><name>1600 Amphitheater Pkwy, Mountain View, CA</name><Status><code>610</code><request>geocode</request></Status></Response></kml>
    EOF

    @gg.locate 'x'

  rescue GoogleGeocode::KeyError => e
    assert_equal 'invalid key', e.message
  else
    flunk 'Error expected'
  end

  def test_locate_missing_address
    URI::HTTP.responses << <<-EOF.strip
<?xml version="1.0" encoding="UTF-8"?><kml xmlns="http://earth.google.com/kml/2.0"><Response><name>1600</name><Status><code>601</code><request>geocode</request></Status></Response></kml>
    EOF

    @gg.locate 'x'

  rescue GoogleGeocode::AddressError => e
    assert_equal 'missing address', e.message
  else
    flunk 'Error expected'
  end

  def test_locate_server_error
    URI::HTTP.responses << <<-EOF.strip
<?xml version='1.0' encoding='UTF-8'?><kml xmlns='http://earth.google.com/kml/2.0'><Response><name>1600 Amphitheater Pkwy, Mountain View, CA</name><Status><code>500</code><request>geocode</request></Status></Response></kml>
    EOF

    @gg.locate 'x'

  rescue GoogleGeocode::Error => e
    assert_equal 'server error', e.message
  else
    flunk 'Error expected'
  end

  def test_locate_too_many_queries
    URI::HTTP.responses << <<-EOF.strip
<?xml version='1.0' encoding='UTF-8'?><kml xmlns='http://earth.google.com/kml/2.0'><Response><name>1600 Amphitheater Pkwy, Mountain View, CA</name><Status><code>620</code><request>geocode</request></Status></Response></kml>
    EOF

    @gg.locate 'x'

  rescue GoogleGeocode::KeyError => e
    assert_equal 'too many queries', e.message
  else
    flunk 'Error expected'
  end

  def test_locate_unavailable_address
    URI::HTTP.responses << <<-EOF.strip
<?xml version="1.0" encoding="UTF-8"?><kml xmlns="http://earth.google.com/kml/2.0"><Response><name>42-44 Hanway Street, London</name><Status><code>603</code><request>geocode</request></Status></Response></kml>
    EOF

    @gg.locate 'x'

  rescue GoogleGeocode::AddressError => e
    assert_equal 'unavailable address', e.message
  else
    flunk 'Error expected'
  end

  def test_locate_unknown_address
    URI::HTTP.responses << <<-EOF.strip
<?xml version="1.0" encoding="UTF-8"?><kml xmlns="http://earth.google.com/kml/2.0"><Response><name>1600</name><Status><code>602</code><request>geocode</request></Status></Response></kml>
    EOF

    @gg.locate 'x'

  rescue GoogleGeocode::AddressError => e
    assert_equal 'unknown address', e.message
  else
    flunk 'Error expected'
  end

end

class TestGoogleGeocodeLocation < Test::Unit::TestCase

  def test_coordinates
    location = GoogleGeocode::Location.new
    location.address = '1600 Amphitheatre Pkwy, Mountain View, CA 94043, USA'
    location.latitude = 37.423021
    location.longitude = -122.083739

    assert_equal [37.423021, -122.083739], location.coordinates
  end

end

