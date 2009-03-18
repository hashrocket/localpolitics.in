require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Bio do
  describe "validation" do
    before do
      @bio = Bio.new
    end
    it "should require a bio" do
      @bio.should have(1).error_on(:bio)
    end
    it "should require a bioguide_id" do
      @bio.should have(1).error_on(:bioguide_id)
    end
  end
end
