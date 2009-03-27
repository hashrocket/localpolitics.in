require File.dirname(__FILE__) + '/../spec_helper.rb'

describe FedSpending do

  describe "construct_url" do
    it "includes zip" do
      FedSpending.construct_url(:zip_code => '53716').should include('recipient_zip=53716')
    end
    it "defaults the fiscal year" do
      FedSpending.construct_url(:zip_code => '53716').should include('fiscal_year=2006')
    end
    it "sets fiscal year if passed in" do
      FedSpending.construct_url(:zip_code => '53716', :fiscal_year => '2008').should include('fiscal_year=2008')
    end
    it "defaults datype" do
      FedSpending.construct_url(:zip_code => '53716').should include('datype=X')
    end
    it "sets datype if passed in" do
      FedSpending.construct_url(:zip_code => '53716', :datype => 'T').should include('datype=T')
    end
    it "defaults max_records" do
      FedSpending.construct_url(:zip_code => '53716').should include('max_records=10')
    end
    it "sets max_records if passed in" do
      FedSpending.construct_url(:zip_code => '53716', :max_records => '20').should include('max_records=20')
    end
    it "raises an error if no zip code is passed in" do
      lambda { FedSpending.construct_url }.should raise_error(ArgumentError)
    end
  end

  describe "format_name" do
    it "returns the titleized name" do
      FedSpending.format_name("ALL CAPS").should == "All Caps"
    end
  end

  describe "top_recipients" do
    before do
      FedSpending.stubs(:construct_url).returns(File.join(RAILS_ROOT, 'spec/fixtures/fed_spending_faads.xml'))
    end
    it "returns an array of hashes when recipients found" do
      FedSpending.top_recipients.all? {|r| r.kind_of?(Hash) }.should be_true
    end
    it "returns an empty array when no recipients found" do
      empty_xml = Nokogiri::XML("<fedspendingSearchResults></fedspendingSearchResults>")
      Nokogiri::XML.stubs(:parse).returns(empty_xml)
      FedSpending.top_recipients.should == []
    end
    it "calls titleize on each recipient name" do
      FedSpending.expects(:format_name).times(10)
      FedSpending.top_recipients(:zip_code => '53716')
    end
    it "includes recipient name" do
      FedSpending.top_recipients.all? {|r| r.has_key?(:name) }.should be_true
    end
    it "includes recipient dollar amount" do
      FedSpending.top_recipients.all? {|r| r.has_key?(:amount) }.should be_true
    end
    it "orders the array based on rank" do
      FedSpending.top_recipients[1][:rank].should == '2'
    end
  end
end

