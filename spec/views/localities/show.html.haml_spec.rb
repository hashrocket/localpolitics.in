require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe "localities/show" do
  before do
    representative_hash = {:senior_senator => fake_legislator, :junior_senator => fake_legislator, :representative => fake_legislator}
    Legislator.stubs(:all_for).returns(representative_hash)
    @representative = CongressPerson.new(fake_legislator)
    @locality = Locality.new "53716"
    @locality.stubs(:representative).returns(@representative)
    @locality.stubs(:has_legislators?).returns(true)
    assigns[:locality] = @locality
    assigns[:party_totals] = {:R => 5, :D => 6}
    template.stubs(:preferred_party_text).returns("You're crazy democratic!")
  end
  it "should render without errors" do
    do_render
  end
  it "links to the congress person show page" do
    do_render
    response.should have_tag("a[href=?]", congress_person_path(@representative.crp_id))
  end
  it "doesn't link to the congress person show page if their is no crp_id" do
    @representative.stubs(:crp_id).returns("")
    @representative.stubs(:full_name).returns("something reasonable")
    do_render
    response.should_not have_tag("a", @representative.full_name)
  end
  it "doesn't list an image for a congress person with no crp_id" do
    @representative.stubs(:has_photo?).returns(false)
    do_render
    response.should_not have_tag("img[src=?]", "/images/congresspeople/#{@representative.photo_id}.jpg")
  end

  describe "representative information" do
    it "displays if there are any legislators" do
      do_render
      response.should have_tag("div#representative_information")
    end
    it "doesn't display with no legislators" do
      @locality.stubs(:has_legislators?).returns(false)
      do_render
      response.should_not have_tag("div#representative_information")
    end
    it "gets the congress person's photo" do
      @representative.expects(:photo).returns(@representative.default_photo_path)
      do_render
    end
  end

  describe "preferred party widget" do
    before do
      assigns[:top_ten_donors] = []
    end
    it "uses the correct div" do
      do_render
      response.should have_tag("#preferred_party")
    end
    it "asks how the zip leans" do
      template.expects(:preferred_party_class).returns('leans_democratic')
      do_render
      response.should have_tag(".leans_democratic")
    end
    it "asks for the preferred party text" do
      template.expects(:preferred_party_text).returns('preferred_party_text')
      do_render
      response.body.should include('preferred_party_text')
    end
  end
  def do_render
    render "/localities/show.html.haml"
  end
end
