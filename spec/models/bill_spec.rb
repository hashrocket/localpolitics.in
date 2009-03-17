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

  describe "cosponsors" do
    before do
      @bill.cosponsor_ids = %w(1 2 3)
    end
    it "returns an array of cosponsors" do
      @bill.cosponsor_ids.should == %w(1 2 3)
    end
  end
end
