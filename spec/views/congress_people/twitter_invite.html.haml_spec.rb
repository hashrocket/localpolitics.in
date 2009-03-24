require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe "twitter_invite view" do
  def do_render
    assigns[:invitation_text] = "test_invitation_text"
    assigns[:subject] = "subject"
    assigns[:congress_person] = CongressPerson.new(fake_legislator)
    render "congress_people/twitter_invite.html.haml"
  end
  it "should have a subject field" do
    do_render
    response.should have_tag("input[type=text][value=?]", "subject")
  end
  it "should have a personal message field" do
    do_render
    response.should have_tag("textarea[name=personal_message]")
  end
  it "should display the boilerplate twitter invitation text" do
    do_render
    response.should have_tag(".invitation_text", "test_invitation_text")
  end
  it "should have a citizen name field" do
    do_render
    response.should have_tag("input[type=text][name=?]", "citizen_name")
  end
  it "should have a citizen email address field" do
    do_render
    response.should have_tag("input[type=text][name=?]", "citizen_email")
  end
  it "should have a submit button" do
    do_render
    response.should have_tag("input[type=submit][value=?]", "Send it!")
  end
end

