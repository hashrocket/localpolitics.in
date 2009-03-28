module CongressPeopleHelper
  def latest_search_or_state_of(congress_person)
    current_location || congress_person.state
  end
end
