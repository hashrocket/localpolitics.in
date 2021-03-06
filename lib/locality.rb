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
        @#{role} ||= CongressPerson.new(legislators[:#{role}]) if valid_role?("#{role}")
      end
    CODE
  end

  def initialize(location_data)
    @location_data = location_data
    geocode
  end

  def cache_key
    "sunrise/#{Digest::SHA1.hexdigest(@location_data)}"
  end

  def geocode
    return if @postal_code || (@latitude && @longitude)
    location = Rails.cache.fetch(cache_key, :expires_in => 1.hour) do
      begin
        self.class.geocoder.locate(@location_data)
      rescue GoogleGeocode::AddressError
      end
    end
    @postal_code = location.postal_code if location
    @latitude, @longitude = location.coordinates if location
  end

  def legislators
    @legislators ||= Sunlight::Legislator.all_for :latitude => @latitude, :longitude => @longitude
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

  def has_legislators?
    legislators.values.any? {|legislator| !legislator.nil? }
  end

  def valid_role?(role)
    !legislators[role.to_sym].nil?
  end

  def has_both_senators?
    senior_senator && junior_senator
  end

  def senator_comparison
    SenatorComparison.for(senior_senator.govtrack_id, junior_senator.govtrack_id)
  end
end

