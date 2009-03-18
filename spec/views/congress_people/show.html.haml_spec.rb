require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe "CongressPerson show view" do

  before do
    @legislator = fake_legislator
    @congress_person = CongressPerson.new(@legislator)
    assigns[:congress_person] = @congress_person
  end

  def do_render
    render "/congress_people/show.html.haml"
  end

  it "should list the congress person" do
    do_render
    response.body.should include(@congress_person.full_name)
  end
  it "should include a photo" do
    template.stubs(:govtrack_photo).returns("<img src='/govtrack/photos/#{@congress_person.govtrack_id}.jpeg'/>")
    do_render
    response.should have_tag("img[src=?]", "/govtrack/photos/#{@congress_person.govtrack_id}.jpeg")
  end
  it "should link to the congress person's website" do
    do_render
    response.should have_tag("a[href=?]", @congress_person.website_url)
  end
  it "should link to the congress person's twitter page" do
    @congress_person.stubs(:twitter_id).returns("congress_person")
    do_render
    response.should have_tag("a[href=?]", "http://twitter.com/#{@congress_person.twitter_id}")
  end
  it "should list the congress person's sponsored bills" do
    @bill = Factory(:bill)
    @congress_person.stubs(:sponsored_bills).returns([@bill])
    @congress_person.stubs(:has_sponsored_bills?).returns(true)
    do_render
    response.should have_tag(".sponsored_bills")
  end
  it "includes the congress person's bio" do
    bio = Factory(:bio)
    @congress_person.stubs(:bio_text).returns(bio.bio)
    do_render
    response.should have_tag(".bio_text", bio.bio)
  end

end
