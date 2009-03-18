Factory.sequence(:user_email) { |n| "user_#{n}@example.com" }

Factory.define Bill do |b|
  b.sponsor_id    1234
  b.cosponsor_ids [1,2,3,4]
  b.title         "I'm just a bill"
  b.description   "... sitting on Capitol Hill"
  b.summary       "Well, it's a long, long journey to the capital city.  It's a long, long wait While I'm sitting in committee, But I know I'll be a law someday."
end

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

Factory.define :bio do |bio|
  bio.bioguide_id 'N00012739'
  bio.bio         'Some text'
end
