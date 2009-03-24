require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Mailer do

  describe "twitter_invite" do
    before do
      @congress_person = CongressPerson.new(fake_legislator)
    end
    it "sends the email" do
      lambda{ Mailer.deliver_twitter_invite(@congress_person, {:subject => 'subject', :from => 'me@example.com', :personal_message => 'hey there!'}) }.should change(ActionMailer::Base.deliveries, :size).by(1)
    end
    it "includes a personal message if there is one" do
      Mailer.create_twitter_invite(@congress_person, {:subject => 'subject', :from => 'me@example.com', :personal_message => 'hey there!'}).body.should include('He or she would like to pass along this personal message')
    end
    it "doesn't include the personal message header if there is no personal message" do
      Mailer.create_twitter_invite(@congress_person, {:subject => 'subject', :from => 'me@example.com'}).body.should_not include('He or she would like to pass along this personal message')
    end
    it "includes the citizen's name if specified" do
      Mailer.create_twitter_invite(@congress_person, {:subject => 'subject', :from => 'me@example.com', :citizen_name => 'Concerned Person'}).body.should include('Concerned Person')
    end
    it "includes 'A citizen' otherwise" do
      Mailer.create_twitter_invite(@congress_person, {:subject => 'subject', :from => 'me@example.com'}).body.should include('A citizen')
    end
  end
end
