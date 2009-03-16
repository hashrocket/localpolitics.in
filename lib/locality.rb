class Locality
  attr_reader :latitude, :longitude, :postal_code
  ROLES = %w(senior_senator junior_senator representative)

  def self.geocoder
    @geocoder ||= GoogleGeocode.new APP_CONFIG[:google_maps_api_key]
  end

  def self.geocoder=(coder)
    @geocoder = coder
  end

  ROLES.each do |role|
    class_eval <<-CODE
      def #{role}
        @#{role} ||= CongressPerson.new(legislators[:#{role}])
      end
    CODE
  end

  def initialize(location_data)
    @location_data = location_data
    @postal_code, @latitude, @longitude = *nil
  end

  def geocode
    return if @postal_code
    location = self.class.geocoder.locate(@location_data)
    @postal_code = location.postal_code
    @latitude, @longitude = location.coordinates
  end

  def legislators
    geocode
    @legislators ||= Legislator.all_for :latitude => @latitude,
                                        :longitude => @longitude
  end

  def congress_people
    ROLES.map{|role| self.send(role)}
  end

  def top_donors
    @donors ||= NewYorkTimes::CampaignFinance.donor_search_by_postal_code(@postal_code)
  end
end

