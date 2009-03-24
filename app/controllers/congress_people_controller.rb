class CongressPeopleController < ApplicationController
  def show
    @tweet_time = Time.now
    @congress_person = CongressPerson.new(Legislator.where(:crp_id => params[:id]))
  end

  def twitter_invite
    @invitation_text = Tweet.invitation_text
    @subject = "Hey, why aren't you on Twitter?"
    @congress_person = CongressPerson.new(Legislator.where(:crp_id => params[:id]))
    render :layout => false
  end

  def send_twitter_invite
    @congress_person = CongressPerson.new(Legislator.where(:crp_id => params[:id]))
    Mailer.deliver_twitter_invite(@congress_person, { :subject => params[:subject], :personal_message => params[:personal_message], :citizen_email => params[:citizen_email], :citizen_name => params[:citizen_name] })
    render :nothing => true
  end
end
