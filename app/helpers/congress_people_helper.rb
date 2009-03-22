module CongressPeopleHelper
  def latest_search_or_state_of(congress_person)
    flash[:zip_code] || congress_person.state
  end
end
