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

  it "sets @legislators to the representatives for a given locality" do
    legislators = Hash.new(
                    :senior_senator => {:first_name => "Bob", :last_name => "Dole"},
                    :junior_senator => {:first_name => "Jane", :last_name => "Doe"},
                    :representative => {:first_name => "Simon", :last_name => "Says"}
                  )
    Legislator.stubs(:all_for).returns(legislators)
    @locality.instance_variable_get(:@legislators).should be_nil
    @locality.legislators
    @locality.instance_variable_get(:@legislators).should == legislators
  end

  it "should return an array of congress persons" do
    stub_out_open_secrets_new
    @locality.congress_people.each do |congress_person|
      congress_person.should be_a_kind_of(CongressPerson)
    end
  end

end
