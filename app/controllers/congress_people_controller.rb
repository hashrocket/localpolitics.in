class CongressPeopleController < ApplicationController
  def show
    @tweet_time = Time.now
    @congress_person = CongressPerson.new(Legislator.where(:crp_id => params[:id]))
  end
end
