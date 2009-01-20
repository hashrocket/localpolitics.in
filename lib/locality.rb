class Locality
  attr_reader :latitude, :longitude, :postal_code

  def self.geocoder
    @geocoder ||= GoogleGeocode.new APP_CONFIG[:google_maps_api_key]
  end

  def self.geocoder=(coder)
    @geocoder = coder
  end

  def initialize(zip)
    @zip = zip
    
    # don't need this yet
    # result = self.class.geocoder.locate(data)
    # @postal_code = result.postal_code
    # @latitude, @longitude = result.coordinates
  end
  
  def legislators
    @legislators ||= Legislator.all_for_zip(@zip)
  end

  def senior_senator
    @senior_senator ||= 
      CongressPerson.new(Legislator.new(legislators.detect { |p| p["legislator"]["district"] == "Senior Seat"}["legislator"]))
  end

  def junior_senator
    @junior_senator ||=
      CongressPerson.new(Legislator.new(legislators.detect { |p| p["legislator"]["district"] == "Junior Seat"}["legislator"]))
  end

  def representative
    @representative ||=
      CongressPerson.new(Legislator.new(legislators.detect { |p| p["legislator"]["district"] =~ /\d+/}["legislator"]))
  end

end

