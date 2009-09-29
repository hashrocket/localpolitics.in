require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe NewYorkTimes::CampaignFinance do

  describe NewYorkTimes::CampaignFinance::ZipSummary do

    def sample_zip_summary
      NewYorkTimes::CampaignFinance::ZipSummary.new(sample_response)
    end

    subject do
      sample_zip_summary
    end

    describe "#total_dollars" do
      subject { sample_zip_summary.total_dollars }
      it { should be_a_kind_of(BigDecimal) }
      it "returns the sum of donations for the zip" do
        should == BigDecimal('51645.61')
      end
    end

    describe "#lean_degree" do
      subject { sample_zip_summary }
      it "returns heavy when donations are more than two to one" do
        subject.lean_degree.should == :heavy
      end
      it "returns light when donations are less than two to one" do
        subject.stubs(:dollars_for).with(:D).returns(BigDecimal('55'))
        subject.stubs(:total_dollars).returns(BigDecimal('104'))
        subject.lean_degree.should == :light
      end
      it "returns wash when donations are equal" do
        subject.stubs(:dollars_for).with(:D).returns(BigDecimal('49'))
        subject.stubs(:total_dollars).returns(BigDecimal('98'))
        subject.lean_degree.should == :wash
      end
    end

    describe "#lean_party" do
      subject { sample_zip_summary.lean_party }
      it "returns the party with the most donations" do
        should == :D
      end
    end

    describe "#percentage_of_donations_for" do
      subject { sample_zip_summary }
      it "returns the correct percentage" do
        subject.percentage_of_donations_for(:D).should be_close(0.78, 0.01)
      end
    end
  end

  describe "totals_by_postal_code" do
    before do
      stub_totals
    end
    it "returns something with keys" do
      NewYorkTimes::CampaignFinance.totals_by_postal_code("53716").should respond_to(:[])
    end
  end

  def stub_totals
    @response = sample_response
    HTTParty.stubs(:get).returns(@response)
  end

  def sample_response
    {"body"=>[{"contribution_count"=>239, "zip"=>"53716", "total"=>31585.66, "full_name"=>"Barack Obama", "party"=>"D"}, {"contribution_count"=>61, "zip"=>"53716", "total"=>7674.42, "full_name"=>"Hillary Clinton", "party"=>"D"}, {"contribution_count"=>9, "zip"=>"53716", "total"=>7300, "full_name"=>"Tommy Thompson", "party"=>"R"}, {"contribution_count"=>7, "zip"=>"53716", "total"=>2001, "full_name"=>"John McCain", "party"=>"R"}, {"contribution_count"=>6, "zip"=>"53716", "total"=>980, "full_name"=>"Mike Huckabee", "party"=>"R"}, {"contribution_count"=>4, "zip"=>"53716", "total"=>695, "full_name"=>"Sam Brownback", "party"=>"R"}, {"contribution_count"=>2, "zip"=>"53716", "total"=>400, "full_name"=>"Dennis J. Kucinich", "party"=>"D"}, {"contribution_count"=>5, "zip"=>"53716", "total"=>315, "full_name"=>"Bill Richardson", "party"=>"D"}, {"contribution_count"=>11, "zip"=>"53716", "total"=>283.53, "full_name"=>"John Edwards", "party"=>"D"}, {"contribution_count"=>4, "zip"=>"53716", "total"=>251, "full_name"=>"Ron Paul", "party"=>"R"}, {"contribution_count"=>1, "zip"=>"53716", "total"=>250, "full_name"=>"Rudy Giuliani", "party"=>"R"}, {"contribution_count"=>3, "zip"=>"53716", "total"=>-90, "full_name"=>"Tom Tancredo", "party"=>"R"}], "status"=>"OK", "copyright"=>"Copyright (c) 2009 The New York Times Company.  All Rights Reserved."}
  end
end
