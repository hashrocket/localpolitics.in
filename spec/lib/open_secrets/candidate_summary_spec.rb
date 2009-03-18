require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe OpenSecrets::CandidateSummary do
  describe "with stubbed out calls" do
    before do
      stub_out_open_secrets_new
      @candidate = OpenSecrets::CandidateSummary.new('N00012739')
    end

    it "should set attr_readers for valid fields" do
      OpenSecrets::CandidateSummary::READERS.each do |reader|
        @candidate.should respond_to(reader)
      end
    end

    it "should format return values" do
      OpenSecrets::CandidateSummary.any_instance.expects(:formatted_return_value).at_least_once
      OpenSecrets::CandidateSummary.new("N00012739")
    end

    it "should have a cash_on_hand attribute" do
      @candidate.cash_on_hand.should == 662399
    end

    it "formats the candidate name" do
      @candidate.full_name.should == "Ander Crenshaw"
    end

    describe "formatted_return_value" do
      it "handles numbers" do
        @candidate.formatted_return_value("123").should == 123
      end
      it "handles strings" do
        @candidate.formatted_return_value("hello").should == "hello"
      end
      it "handles dates" do
        @candidate.formatted_return_value("12/31/2008").should == Date.parse("12/31/2008")
      end
      it "handles nil" do
        @candidate.formatted_return_value(nil).should == nil
      end
    end
  end

  describe "without stubbed out calls" do
    it "returns an empty response if we're over our call limit" do
      HTTParty.stubs(:get).returns("call limit has been reached")
      @candidate = OpenSecrets::CandidateSummary.new('N00012739')
      @candidate.summary_result('N00012739')["response"]["summary"].values.all?{|v| v.nil?}.should be_true
    end
  end

end
