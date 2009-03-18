require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Committee do
  describe "validation" do
    it "requires name" do
      committee = Committee.new
      committee.should_not be_valid
      committee.should have(1).error_on(:name)
    end
  end

  it 'knows its committee memberships' do
    Committee.new.should respond_to(:committee_memberships)
  end
end
