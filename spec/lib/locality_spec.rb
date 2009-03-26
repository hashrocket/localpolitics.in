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

  it "should return an array of congress people" do
    OpenSecrets::CandidateSummary.any_instance.stubs(:summary_result).returns(fake_candidate_summary_response)
    summary = OpenSecrets::CandidateSummary.new('some id')
    OpenSecrets::CandidateSummary.stubs(:new).returns(summary)
    Legislator.stubs(:all_for).returns(:senior_senator => fake_legislator, :junior_senator => fake_legislator, :representative => fake_legislator)
    @locality.congress_people.each do |congress_person|
      congress_person.should be_a_kind_of(CongressPerson)
    end
  end

  describe "role methods" do
    it "returns nil if the legislator is nil" do
      Legislator.stubs(:all_for).returns(no_legislators_returned)
      @locality.stubs(:valid_role?).returns(false)
      Locality::ROLES.each do |role|
        @locality.send(role).should be_nil
      end
    end
    it "returns a congress person otherwise" do
      Legislator.stubs(:all_for).returns(:senior_senator => fake_legislator, :junior_senator => fake_legislator, :representative => fake_legislator)
      @locality.stubs(:valid_role?).returns(true)
      Locality::ROLES.each do |role|
        @locality.send(role).should be_a_kind_of(CongressPerson)
      end
    end
  end

  describe "#geocode" do
    it "fails gracefully" do
      Locality.geocoder.expects(:locate).raises(GoogleGeocode::AddressError, "unknown address")
      lambda { Locality.new "99987" }.should_not raise_error
    end
  end

  describe "valid_role?" do
    it "returns false if the legislator is nil" do
      @locality.stubs(:legislators).returns(:senior_senator => nil)
      @locality.valid_role?("senior_senator").should be_false
    end
    it "returns true otherwise" do
      @locality.stubs(:legislators).returns(:senior_senator => CongressPerson.new(fake_legislator))
      @locality.valid_role?("senior_senator").should be_true
    end
  end

  describe "#has_district_data?" do

    describe "with no postal code or latitude and longitude" do
      it "returns false" do
        @locality.stubs(:postal_code)
        @locality.stubs(:latitude)
        @locality.stubs(:longitude)
        @locality.should_not have_district_data
      end
    end

    describe "with a postal code" do
      before do
        @locality.stubs(:postal_code).returns('53716')
      end
      it "returns true if sunlight districts are found" do
       Sunlight::District.stubs(:all_from_zipcode).returns([stub('a district')])
       @locality.should have_district_data
      end
      it "returns false if they're not" do
       Sunlight::District.stubs(:all_from_zipcode).returns([])
       @locality.should_not have_district_data
      end
    end

    describe "without a postal code and with latitude and longitude" do
      before do
        @locality.stubs(:postal_code).returns(nil)
        @locality.stubs(:latitude).returns('43.062071')
        @locality.stubs(:longitude).returns('-89.400846')
      end
      it "returns true if sunlight districts are found" do
       Sunlight::District.stubs(:get_from_lat_long).returns(stub('a district'))
       @locality.should have_district_data
      end
      it "returns false if they're not" do
       Sunlight::District.stubs(:get_from_lat_long).returns(nil)
       @locality.should_not have_district_data
      end
    end
  end

  describe "has_legislators?" do
    it "should return true if any of the legislators exist" do
      @locality.stubs(:legislators).returns(:senior_senator => nil, :junior_senator => fake_legislator, :representative => nil)
      @locality.should have_legislators
    end
    it "should return false otherwise" do
      @locality.stubs(:legislators).returns(:senior_senator => nil, :junior_senator => nil, :representative => nil)
      @locality.should_not have_legislators
    end
  end

  def no_legislators_returned
    {:senior_senator => nil, :junior_senator => nil, :representative => nil}
  end

end
