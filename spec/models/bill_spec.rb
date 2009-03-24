require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Bill do
  before do
    @bill = Bill.new
  end

  describe "validation" do
    it "requires a title" do
      @bill.should_not be_valid
      @bill.should have(1).error_on(:title)
    end
    it "requires a sponsor" do
      @bill.should_not be_valid
      @bill.should have(1).error_on(:sponsor_id)
    end
  end

  describe "cosponsor_ids" do
    before do
      @bill.cosponsor_ids = %w(1 2 3)
    end
    it "returns an array of cosponsors" do
      @bill.cosponsor_ids.should == %w(1 2 3)
    end
  end

  describe "#cosponsor_names" do
    before do
      @bill = Factory(:bill)
      @cp1 = stub('congress_person', :full_name => "Bill Nelson")
      @cp2 = stub('congress_person', :full_name => "Russ Feingold")
    end
    it "returns a comma delimited list of congress person names" do
      CongressPerson.stubs(:find_all_by_govtrack_id).returns([@cp1,@cp2])
      @bill.cosponsor_names.should == "Bill Nelson, Russ Feingold"
    end
    it "returns nil if no cosponsor_ids set" do
      CongressPerson.stubs(:find_all_by_govtrack_id)
      @bill.cosponsor_ids = nil
      @bill.cosponsor_names.should be_nil
    end
  end

  describe "#sponsor_name" do
    before do
      @bill = Factory(:bill)
      stub_out_legislator_get_json_data
      CongressPerson.stubs(:find)
    end

    it "finds a congress person by govtrack_id" do
      CongressPerson.expects(:find).with(:govtrack_id => @bill.sponsor_id)
      @bill.sponsor_name
    end
    it "returns the congress person's name" do
      CongressPerson.stubs(:find).returns(mock('congress_person', :full_name => "Bill Nelson"))
      @bill.sponsor_name.should == "Bill Nelson"
    end
    it "returns nil when no congress person found" do
      CongressPerson.stubs(:find).returns(nil)
      @bill.sponsor_name.should be_nil
    end
  end

  describe "link" do
    before do
      @bill = Factory(:bill)
    end
    it "returns the correct url" do
      @bill.link.should == "http://thomas.loc.gov/cgi-bin/bdquery/z?d110:h.res.01000:"
    end
    it "returns nil if the session is nil" do
      @bill.stubs(:session).returns(nil)
      @bill.link.should be_nil
    end
    it "returns nil if the bill_type is nil" do
      @bill.stubs(:bill_type).returns(nil)
      @bill.link.should be_nil
    end
    it "returns nil if the number is nil" do
      @bill.stubs(:number).returns(nil)
      @bill.link.should be_nil
    end
  end
end
