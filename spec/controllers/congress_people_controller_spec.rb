require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CongressPeopleController do
  before do
    @legislator = fake_legislator
    @congress_person = CongressPerson.new(@legislator)
    Sunlight::Legislator.stubs(:where).returns(@legislator)
    CongressPerson.stubs(:new).returns(@congress_person)
  end

  describe "GET show" do
    it "should load the correct congress person" do
      Sunlight::Legislator.expects(:where).with(:crp_id => 'the id').returns(@legislator)
      get :show, :id => 'the id'
    end
  end

  describe "GET twitter_invite" do
    it "renders the twitter_invite view" do
      do_get
      response.should render_template('twitter_invite')
    end
    it "sets the invitation_text instance variable" do
      do_get
      assigns[:invitation_text].should == Tweet.invitation_text
    end
    it "sets the subject" do
      do_get
      assigns[:subject].should == "Hey, why aren't you on Twitter?"
    end
    it "sets the congress_person" do
      do_get
      assigns[:congress_person].should == @congress_person
    end
    def do_get
      get :twitter_invite, :id => @congress_person.crp_id
    end
  end

  describe "POST send_twitter_invite" do
    it "sends an email" do
      Mailer.expects(:deliver_twitter_invite).with(@congress_person, { :subject => 'subject', :citizen_email => 'me@example.com', :citizen_name => 'citizen_name', :personal_message => 'hey there!' })
      xhr :post, :send_twitter_invite, :id => @congress_person.crp_id, :subject => 'subject', :citizen_email => 'me@example.com', :citizen_name => 'citizen_name', :personal_message => 'hey there!'
    end
  end
end
