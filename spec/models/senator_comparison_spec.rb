require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SenatorComparison do
  subject do
    Factory.build(:senator_comparison)
  end

  describe "validation" do
    before do
      @senator_comparison = SenatorComparison.new
    end
    it "requires govtrack_id_1" do
      @senator_comparison.should have(1).error_on(:govtrack_id_1)
    end
    it "requires govtrack_id_2" do
      @senator_comparison.should have(1).error_on(:govtrack_id_2)
    end
  end

  describe "::for" do
    before do
      SenatorComparison.stubs(:find_or_initialize_by_govtrack_id_1_and_govtrack_id_2).returns(subject)
      subject.stubs(:expired?).returns(false)
    end

    describe "when a recently scraped record exists" do
      it "returns the existing record" do
        SenatorComparison.for(subject.govtrack_id_1, subject.govtrack_id_2).should == subject
      end
    end

    it "checks for expiration" do
      subject.expects(:scrape_if_expired)
      SenatorComparison.for(subject.govtrack_id_1, subject.govtrack_id_2)
    end
  end

  describe "#url" do
    it "should be the correct url" do
      subject.url.should == "http://www.opencongress.org/person/compare?person1=300042&person2=300061"
    end
  end

  describe "#scrape_if_expired" do
    it "scrapes if it is expired" do
      subject.stubs(:expired?).returns(true)
      subject.expects(:scrape)
      subject.scrape_if_expired
    end
  end

  describe "#expired?" do
    it "should be false if there is no updated_at" do
      subject.stubs(:updated_at)
      subject.should be_expired
    end
    it "should be true if the cache is more than 2 weeks old" do
      subject.stubs(:updated_at).returns(15.days.ago)
      subject.should be_expired
    end
    it "should be false if the cache is more than 2 weeks old" do
      subject.stubs(:updated_at).returns(13.days.ago)
      subject.should_not be_expired
    end
  end

  describe "#document" do
    before do
      FakeWeb.register_uri(subject.url, :string => "<foo></foo>")
    end
    it "should be a Nokogiri object" do
      subject.document.should be_a_kind_of(Nokogiri::HTML::Document)
    end
    it "should wrap the contents at the url" do
      subject.document.at("foo").should be
    end
  end

  describe "#scrape" do
    before do
      FakeWeb.register_uri(subject.url, :string => %<<html><div class="cols-box comps"><h4>LOL SPELLING ERROR</h4><ins>;)</ins></div></html>>)
      subject.stubs(:save!)
    end
    it "should forcefully save the record" do
      subject.expects(:save!)
      subject.scrape
    end
    it "gets the HTML from the remote source" do
      subject.scrape
      subject.body.should include("<ins>;)</ins>")
    end

    it "removes the h4" do
      subject.scrape
      subject.body.should_not include("<h3>")
    end
  end
end
