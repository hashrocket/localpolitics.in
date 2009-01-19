class User < ActiveRecord::Base
  validates_presence_of :email
  has_many :subscriptions

  def self.from_location_and_email(location, email)
    user = find_or_create_by_email(email)
    Subscription.add_location_to_user(location, user)
    user
  end

end
