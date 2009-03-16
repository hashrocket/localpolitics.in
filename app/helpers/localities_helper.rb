module LocalitiesHelper
  def party_for(representative)
    party = representative.party
    content_tag :span, party, :class => party.downcase
  end

  def district_id_for(representative)
    representative.senator? ? representative.district : "District ID: #{representative.district}"
  end
end
