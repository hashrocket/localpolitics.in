class CommitteeMembership < ActiveRecord::Base
  belongs_to :committee
  validates_presence_of   :committee_id, :govtrack_id
  validates_uniqueness_of :committee_id, :scope => :govtrack_id
end
