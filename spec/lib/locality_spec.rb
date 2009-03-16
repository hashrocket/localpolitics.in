require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Locality do
  before do
    @locality = Locality.new "32250"
    @lat = Locality.geocoder.fake_data[:latitude]
    @lon = Locality.geocoder.fake_data[:longitude]
  end

  it "retrieves legislators by latitude and longitude" do
    Legislator.expects(:all_for).with(:latitude => @lat, :longitude => @lon)
    @locality.legislators
  end

  it "returns a CongressPerson for the senior senator seat" do
    legislators = Hash.new(:senior_senator => {:first_name => "Bob"})
    @locality.expects(:legislators).returns(legislators)
    CongressPerson.expects(:new).with(legislators[:senior_senator])
    @locality.senior_senator
  end
end
