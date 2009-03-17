class Bill < ActiveRecord::Base
  validates_presence_of :title, :sponsor_id
  serialize :cosponsor_ids
end
