require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CongressPerson do
  before do
    stub_out_open_secrets_new
    @legislator = fake_legislator
    @congress_person = CongressPerson.new(@legislator)
  end

  it "knows which attributes to display in the candidate summary" do
    @congress_person.should respond_to(:summary_attributes)
  end

  it "knows which attributes are currency values" do
    [:spent, :cash_on_hand, :total, :debt].each do |attribute|
      @congress_person.currency_attribute?(attribute).should be
    end
  end

  it "loads instance variables correctly" do
    CongressPerson::MAP.each do |key, value|
      @congress_person.should respond_to(key)
    end
  end

  it "has a youtube_url" do
    @congress_person.should respond_to(:youtube_url)
  end

  describe "can_has_youtubes?" do
    it "returns true if the congress person has a youtube_url" do
      @congress_person.stubs(:youtube_url).returns("http://youtube.com/something")
      @congress_person.can_has_youtubes?.should be_true
    end
    it "returns false otherwise" do
      @congress_person.stubs(:youtube_url).returns("")
      @congress_person.can_has_youtubes?.should be_false
    end
  end

  describe "tweets" do
    it "should ask Tweet to get recent tweets" do
      @congress_person.stubs(:twitters?).returns(true)
      Tweet.expects(:recent).returns([Tweet.new(:text => 'tweet', :created_at => Time.now.utc)])
      @congress_person.tweets
    end
  end

  it "#twitters? returns true with a twitter_id" do
    @congress_person.stubs(:twitter_id).returns("twitterer")
    @congress_person.twitters?.should be_true
  end
  it "#twitters? returns false otherwise" do
    @congress_person.stubs(:twitter_id).returns("")
    @congress_person.twitters?.should be_false
  end

  it "knows it's bioguide_id" do
    @congress_person.bioguide_id.should == @congress_person.photo_id
  end

  describe "#bio_text" do
    it "returns the bio_text if one exists" do
      bio = Factory(:bio)
      Bio.expects(:find_by_bioguide_id).returns(bio)
      @congress_person.bio_text.should == bio.bio
    end
    it "returns nil otherwise" do
      @congress_person.bio_text.should be_nil
    end
  end

  describe "#has_bio_text?" do
    it "knows if it doesn't have a bio" do
      @congress_person.has_bio_text?.should_not be_true
    end
    it "knows if it has a bio" do
      @congress_person.expects(:bio_text).returns(stub('a bio_text'))
      @congress_person.has_bio_text?.should be_true
    end
  end

  describe "legislation methods" do
    before do
      @b1 = Factory(:bill, :sponsor_id => @congress_person.govtrack_id)
      @b2 = Factory(:bill, :sponsor_id => @congress_person.govtrack_id)
    end
    describe "#introduced_bills" do
      it "returns an array of introduced bills" do
        Bill.stubs(:find_all_by_sponsor_id).returns([@b1,@b2])
        @congress_person.introduced_bills.should == [@b1,@b2]
      end
      it "returns empty array when no sponsored bills found" do
        CongressPerson.new(stub_everything('legislator')).introduced_bills.should == []
      end
    end
    describe "#has_introduced_bills?" do
      it "returns true when bills exist" do
        @congress_person.stubs(:introduced_bills).returns([@b1,@b2])
        @congress_person.has_introduced_bills?.should be_true
      end
      it "returns false when no bills exist" do
        @congress_person.stubs(:introduced_bills).returns([])
        @congress_person.has_introduced_bills?.should be_false
      end
    end
    describe "sponsored_bills" do
      it "returns an array of sponsored bills" do
        Bill.stubs(:find).returns([@b1, @b2])
        @congress_person.sponsored_bills.should == [@b1, @b2]
      end
      it "returns an empty array with no sponsored bills" do
        Bill.stubs(:find).returns([])
        @congress_person.sponsored_bills.should == []
      end
    end
    describe "has_sponsored_bills?" do
      it "returns true when sponsored bills exist" do
        @congress_person.stubs(:sponsored_bills).returns([@b1, @b2])
        @congress_person.should have_sponsored_bills
      end
      it "returns false otherwise" do
        @congress_person.stubs(:sponsored_bills).returns([])
        @congress_person.should_not have_sponsored_bills
      end
    end
  end

  it "knows if it is a senator" do
    @congress_person.stubs(:title).returns('Senator')
    @congress_person.should be_a_senator
  end
  it "knows if it is not a senator" do
    @congress_person.stubs(:title).returns('Representative')
    @congress_person.should_not be_a_senator
  end

  it "returns a single legislator by searching with a hashed param" do
    Sunlight::Legislator.expects(:where).returns(@legislator)
    CongressPerson.find(:govtrack_id => "30001").should be_a_kind_of(CongressPerson)
  end

  it "returns multiple legislators by searching with an array of params" do
    Sunlight::Legislator.expects(:all_where).returns([@legislator])
    CongressPerson.stubs(:new).returns(@congress_person)
    congress_people = CongressPerson.find_all_by_govtrack_id(["30001"])
    congress_people.should be_a_kind_of(Array)
    congress_people.should include(@congress_person)
  end

  describe "committees" do
    it "returns an empty array if there are no committee memberships for the congress person" do
      CommitteeMembership.stubs(:find_all_by_govtrack_id).returns([])
      @congress_person.committees.should be_empty
    end
    it "returns an array of Committees" do
      committee = Factory(:committee)
      committee_membership = CommitteeMembership.new(:govtrack_id => @congress_person.govtrack_id, :committee_id => committee.id)
      CommitteeMembership.stubs(:find_all_by_govtrack_id).returns([committee_membership])
      @congress_person.committees.all?{|c| c.kind_of? Committee }.should be_true
    end
  end

  describe "has_committees?" do
    it "returns true if there are committees" do
      @congress_person.stubs(:committees).returns([Factory(:committee)])
      @congress_person.has_committees?.should be_true
    end
    it "returns false with no committees" do
      @congress_person.stubs(:committees).returns([])
      @congress_person.has_committees?.should be_false
    end
  end

  describe "has_photo?" do
    it "returns false if there's no photo_id" do
      @congress_person.stubs(:photo_id).returns("")
      File.stubs(:exists?).returns(true)
      @congress_person.has_photo?.should be_false
    end
    it "returns false if the photo path doesn't exist" do
      @congress_person.stubs(:photo_id).returns("12")
      File.expects(:exists?).with("#{RAILS_ROOT}/public#{@congress_person.photo_path}").returns(false)
      @congress_person.has_photo?.should be_false
    end
    it "returns true if there is a photo_id and the photo path exists" do
      @congress_person.has_photo?.should be_true
    end
  end

  describe "photo" do
    it "returns photo_path if the congress person has a photo" do
      @congress_person.stubs(:has_photo?).returns(true)
      @congress_person.expects(:photo_path).returns("a photo path")
      @congress_person.photo.should == "a photo path"
    end
    it "returns default photo otherwise" do
      @congress_person.stubs(:has_photo?).returns(false)
      @congress_person.expects(:default_photo_path).returns("a default photo")
      @congress_person.photo.should == "a default photo"
    end
  end

  describe "has_open_congress_id?" do
    it "returns true if there is an open congress id" do
      @congress_person.has_open_congress_id?.should be_true
    end
    it "returns false if it's blank" do
      @congress_person.stubs(:crp_id).returns("")
      @congress_person.has_open_congress_id?.should be_false
    end
  end

  describe "latest_words" do
    it "asks CapitolWord for it's words" do
      CapitolWord.expects(:latest_for).with(@congress_person, {})
      @congress_person.latest_words
    end
  end
end
