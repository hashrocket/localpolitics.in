require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CongressPeopleHelper do
  describe "#latest_search_or_state" do
    before do
      @congress_person = stub(:state => 'NY')
    end

    it "returns the latest search" do
      helper.stubs(:current_location).returns('12345')
      helper.latest_search_or_state_of(@congress_person).should == '12345'
    end

    it "returns the state of the congress person" do
      helper.stubs(:current_location)
      helper.latest_search_or_state_of(@congress_person).should == 'NY'
    end
  end
end
