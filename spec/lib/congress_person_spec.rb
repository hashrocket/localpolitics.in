require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe CongressPerson do
  before do
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

  describe "legislation methods" do
    before do
      @b1 = Factory(:bill, :sponsor_id => @congress_person.govtrack_id)
      @b2 = Factory(:bill, :sponsor_id => @congress_person.govtrack_id)
    end
    describe "#sponsored_bills" do
      it "returns an array of sponsored bills" do
        Bill.stubs(:find_all_by_sponsor_id).returns([@b1,@b2])
        @congress_person.sponsored_bills.should == [@b1,@b2]
      end
      it "returns empty array when no sponsored bills found" do
        CongressPerson.new(stub_everything('legislator')).sponsored_bills.should == []
      end
    end
    describe "#has_sponsored_bills?" do
      it "returns true when bills exist" do
        Bill.stubs(:find_all_by_sponsor_id).returns([@b1,@b2])
        @congress_person.has_sponsored_bills?.should be_true
      end
      it "returns false when no bills exist" do
        Bill.stubs(:find_all_by_sponsor_id).returns([])
        @congress_person.has_sponsored_bills?.should be_false
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
    Legislator.expects(:where).returns(@legislator)
    CongressPerson.find(:govtrack_id => "30001").should be_a_kind_of(CongressPerson)
  end

  it "returns multiple legislators by searching with an array of params" do
    Legislator.expects(:all_where).returns([@legislator])
    CongressPerson.stubs(:new).returns(@congress_person)
    congress_people = CongressPerson.find_all_by_govtrack_id(["30001"])
    congress_people.should be_a_kind_of(Array)
    congress_people.should include(@congress_person)
  end
end
