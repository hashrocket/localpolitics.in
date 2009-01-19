Factory.sequence(:user_email) { |n| "user_#{n}@example.com" }

Factory.define User do |u|
  u.email { Factory.next(:user_email) }
end

Factory.define Subscription do |s|
  s.location_data "32250"
  s.postal_code   "32250"
  s.latitude      "30.3177"
  s.longitude     "-81.41416"
  s.association   :user
end
