class Committee < ActiveRecord::Base
  has_many :committee_memberships
  validates_presence_of :name
end
