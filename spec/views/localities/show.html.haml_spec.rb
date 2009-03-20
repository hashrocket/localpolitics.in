require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe "localities/show" do
  before do
    Legislator.stubs(:all_for).returns({:senior_senator => fake_legislator, :junior_senator => fake_legislator, :representative => fake_legislator})
    @locality = Locality.new "53716"
    assigns[:locality] = @locality
    assigns[:party_totals] = {:R => 5, :D => 6}
    template.stubs(:preferred_party_text).returns("You're crazy democratic!")
  end
  it "should render without errors" do
    do_render
  end
  describe "preferred party widget" do
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
