class Bill < ActiveRecord::Base
  validates_presence_of :title, :sponsor_id
  serialize :cosponsor_ids

  def sponsor_name
    if congress_person = CongressPerson.find(:govtrack_id => sponsor_id)
      congress_person.full_name
    end
  end

  def cosponsor_names
    return if cosponsor_ids.blank?
    CongressPerson.find_all_by_govtrack_id(cosponsor_ids).map(&:full_name).join(", ")
  end

  def link
    return if session.blank? || bill_type.blank? || number.blank?
    "http://thomas.loc.gov/cgi-bin/bdquery/z?d#{session}:#{bill_type}#{number}:"
  end
end
