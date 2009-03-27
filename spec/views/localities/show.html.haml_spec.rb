require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe "localities/show" do
  before do
    representative_hash = {:senior_senator => fake_legislator, :junior_senator => fake_legislator, :representative => fake_legislator}
    Legislator.stubs(:all_for).returns(representative_hash)
    @representative = CongressPerson.new(fake_legislator)
    @locality = Locality.new "53716"
    @locality.stubs(:representative).returns(@representative)
    @locality.stubs(:has_legislators?).returns(true)
    @locality.stubs(:senator_comparison).returns("senator comparison")
    latest_words = [CapitolWord.new('word' => 'word', 'word_count' => 12)]
    @locality.senior_senator.stubs(:latest_words).returns(latest_words)
    @locality.junior_senator.stubs(:latest_words).returns(latest_words)
    @locality.representative.stubs(:latest_words).returns(latest_words)
    assigns[:locality] = @locality
    assigns[:party_totals] = stub('zip_summary', :lean_party => :D, :lean_degree => :light, :percentage_of_donations_for => 0.78)
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
    it "links the image" do
      @representative.stubs(:photo).returns(@representative.default_photo_path)
      do_render
      response.should have_tag("a[href=?]", congress_person_path(@representative.crp_id)) do
        with_tag("img[src*=?]", @representative.default_photo_path)
      end
    end
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

  describe "government spending widget" do
    before do
      @top_recipients = [{:name => 'name', :amount => '17', :rank => 1}]
      assigns[:top_recipients] = @top_recipients
    end
    it "uses the correct div" do
      do_render
      response.should have_tag("#government_spending")
    end
    it "includes top recipients if found" do
      do_render
      response.should have_tag(".top_recipients") do
        @top_recipients.each do |recipient|
          with_tag(".recipient h4 a.lucky", recipient[:name])
          with_tag(".recipient p", /#{recipient[:amount]}/)
        end
      end
    end
    it "doesn't include the widget if no recipients found" do
      assigns[:top_recipients] = []
      do_render
      response.should_not have_tag("#government_spending")
    end
  end

  describe "presidential donors widget" do
    before do
      @top_ten_donors = [['donor_name', 500]]
      assigns[:top_ten_donors] = @top_ten_donors
    end
    it "links to Google's I'm Feeling Lucky search" do
      do_render
      response.should have_tag("#top_donors") do
        @top_ten_donors.each do |donor|
          with_tag(".donor h4 a.lucky", 'donor_name')
          with_tag(".donor p", /500/)
        end
      end
    end
  end

  def do_render
    render "/localities/show.html.haml"
  end

  it "should list a comparison of senators" do
    do_render
    response.should have_tag("#senator_comparison", /senator comparison/)
  end
end
