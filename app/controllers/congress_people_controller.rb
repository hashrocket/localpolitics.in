class CongressPeopleController < ApplicationController
  def show
    @congress_person = CongressPerson.new(Legislator.where(:crp_id => params[:id]))
  end
end
