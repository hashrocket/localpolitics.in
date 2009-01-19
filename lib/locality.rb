class Locality
  attr_reader :latitude, :longitude, :postal_code

  def self.geocoder
    @geocoder ||= GoogleGeocode.new APP_CONFIG[:google_maps_api_key]
  end

  def initialize(data)
    result = self.class.geocoder.locate(data)
    @postal_code = result.postal_code
    @latitude, @longitude = result.coordinates
  end

  def congress_people
    return @congress_people if @congress_people
    @congress_people = Hash.new

    legislators = Legislator.all_for(:latitude => self.latitude, :longitude => self.longitude)

    legislators.each do |title, person|
      @congress_people[title] = CongressPerson.new(person)
    end
    @congress_people
  end

  def senior_senator
    congress_people[:senior_senator]
  end

  def junior_senator
    congress_people[:junior_senator]
  end

  def representative
    congress_people[:representative]
  end

end

