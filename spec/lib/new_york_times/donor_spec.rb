require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe NewYorkTimes::Donor do
  def sample_donor_attributes(extra = {})
    {
      :prefix => "Mr.",
      :first_name => "William",
      :middle_name => "Henry",
      :last_name => "Gates",
      :suffix => "III",
      :address1 => "123 Sesame St",
      :city => "Hackensack",
      :state => "AK",
      :zip5 => "90210"
    }.with_indifferent_access.merge(extra)
  end

  def sample_donation_attributes(extra = {})
    sample_donor_attributes.inject({}) {|h,(k,v)| h.update("donor_#{k}" => v)}.merge(
      "donation_amount" => 1000,
      "donation_date" => Date.new(2009,1,1)
    ).merge(extra)
  end

  subject do
    NewYorkTimes::Donor.new(sample_donor_attributes)
  end

  it "should have a name" do
    subject.name.should == "Mr. William Henry Gates III"
  end

  it "should have an address" do
    subject.address.should == "123 Sesame St\nHackensack, AK 90210"
  end

  it "should titleize only UPPERCASE attributes" do
    NewYorkTimes::Donor.new(:first_name => "RONALD", :last_name => "McDonald").name == "Ronald McDonald"
  end

  describe "#to_s" do
    it "should be 'Name unavailable' for a blank name" do
      NewYorkTimes::Donor.new({}).to_s.should == "Name unavailable"
    end

    it "should be the name otherwise" do
      subject.to_s.should == subject.name
    end
  end

  describe "::top_by_zip" do
    subject do
      NewYorkTimes::CampaignFinance.stubs(:donor_search_by_postal_code).returns('results' => @donation_attributes)
      NewYorkTimes::Donor.top_by_zip('99999')
    end

    it "should roll up duplicate donors" do
      @donation_attributes = [sample_donation_attributes, sample_donation_attributes]
      subject.should have(1).items
    end

    it "should separate distinct donors" do
      @donation_attributes = [sample_donation_attributes, sample_donation_attributes('donor_suffix' => 'II')]
      subject.should have(2).items
    end
  end

end
