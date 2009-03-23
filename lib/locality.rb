require 'digest/sha1'

class Locality
  attr_reader :latitude, :longitude, :postal_code, :location_data
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
    geocode
  end

  def cache_key
    "sunrise/#{Digest::SHA1.hexdigest(@location_data)}"
  end

  def geocode
    return if @postal_code || (@latitude && @longitude)
    location = Rails.cache.fetch(cache_key, :expires_in => 1.hour) do
      self.class.geocoder.locate(@location_data)
    end
    @postal_code = location.postal_code
    @latitude, @longitude = location.coordinates
  end

  def legislators
    @legislators ||= Legislator.all_for :latitude => @latitude,
                                        :longitude => @longitude
  end

  def congress_people
    ROLES.map{|role| self.send(role)}
  end

  def top_donors
    @donors ||= NewYorkTimes::CampaignFinance.donor_search_by_postal_code(@postal_code)
  end

  def has_district_data?
    return Sunlight::District.all_from_zipcode(postal_code).any? if postal_code
    return !Sunlight::District.get_from_lat_long(latitude, longitude).nil? if latitude && longitude
    false
  end
end

