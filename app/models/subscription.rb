class Subscription < ActiveRecord::Base
  belongs_to :user

  before_create :parse_location_data!

  GeoCoder = GoogleGeocode.new APP_CONFIG[:google_maps_api_key]

  def geocoder; GeoCoder; end

  def self.add_location_to_user(location, user)
    subscription = user.subscriptions.find_by_location_data(location)
    subscription ||= user.subscriptions.create(:location_data => location)
    subscription
  end

  def parse_location_data!
    self.postal_code = geocoder.locate(location_data).postal_code
  end
end

