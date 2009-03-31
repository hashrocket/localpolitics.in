module LocalitiesHelper
  def party_for(representative)
    party = representative.party
    content_tag :span, party, :class => party.downcase
  end

  def district_id_for(representative)
    text = if representative.senator?
      representative.district
    else
      if representative.district == "0"
        link_to 'At-Large Seat', "http://wiki.answers.com/Q/What_is_an_at-large_representative", :title => "What is an at-large representative?"
      else
        "District ID: #{representative.district}"
      end
    end
    text += " in #{representative.state}"
  end

  def link_to_senator_comparison(locality)
    link_to "View full comparison", "http://www.opencongress.org/person/compare?person1=#{locality.senior_senator.govtrack_id}&person2=#{locality.junior_senator.govtrack_id}&commit=Compare"
  end
end
