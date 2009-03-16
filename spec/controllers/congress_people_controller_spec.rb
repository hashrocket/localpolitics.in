require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CongressPeopleController do
  describe "GET show" do
    before do
      @legislator = fake_legislator
      @congress_person = CongressPerson.new(@legislator)
    end
    it "should load the correct congress person" do
      CongressPerson.expects(:new).with('the id').returns(@congress_person)
      get :show, :id => 'the id'
    end
  end
end
