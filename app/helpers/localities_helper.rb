module LocalitiesHelper
  def party_for(representative)
    party = representative.party
    content_tag :span, party, :class => party.downcase
  end
end
