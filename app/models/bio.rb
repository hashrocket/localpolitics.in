class Bio < ActiveRecord::Base
  validates_presence_of :bio, :bioguide_id
end
