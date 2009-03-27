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
end
