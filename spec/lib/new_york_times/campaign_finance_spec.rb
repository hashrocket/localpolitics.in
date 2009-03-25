require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe NewYorkTimes::CampaignFinance do

  describe "totals_by_postal_code" do
    before do
      stub_totals
    end
    it "returns a hash" do
      NewYorkTimes::CampaignFinance.totals_by_postal_code("53716").should be_a_kind_of(Hash)
    end
  end

  describe "party_totals_by_postal_code" do
    before do
      stub_totals
    end
    it "returns a hash of party and total" do
      party_totals = NewYorkTimes::CampaignFinance.party_totals_by_postal_code("53716")
      party_totals[:D].should == 40258.61
      party_totals[:R].should == 11387
    end
  end

  def stub_totals
    @response = {"results"=>[{"contribution_count"=>239, "zip"=>"53716", "total"=>31585.66, "full_name"=>"Barack Obama", "party"=>"D"}, {"contribution_count"=>61, "zip"=>"53716", "total"=>7674.42, "full_name"=>"Hillary Clinton", "party"=>"D"}, {"contribution_count"=>9, "zip"=>"53716", "total"=>7300, "full_name"=>"Tommy Thompson", "party"=>"R"}, {"contribution_count"=>7, "zip"=>"53716", "total"=>2001, "full_name"=>"John McCain", "party"=>"R"}, {"contribution_count"=>6, "zip"=>"53716", "total"=>980, "full_name"=>"Mike Huckabee", "party"=>"R"}, {"contribution_count"=>4, "zip"=>"53716", "total"=>695, "full_name"=>"Sam Brownback", "party"=>"R"}, {"contribution_count"=>2, "zip"=>"53716", "total"=>400, "full_name"=>"Dennis J. Kucinich", "party"=>"D"}, {"contribution_count"=>5, "zip"=>"53716", "total"=>315, "full_name"=>"Bill Richardson", "party"=>"D"}, {"contribution_count"=>11, "zip"=>"53716", "total"=>283.53, "full_name"=>"John Edwards", "party"=>"D"}, {"contribution_count"=>4, "zip"=>"53716", "total"=>251, "full_name"=>"Ron Paul", "party"=>"R"}, {"contribution_count"=>1, "zip"=>"53716", "total"=>250, "full_name"=>"Rudy Giuliani", "party"=>"R"}, {"contribution_count"=>3, "zip"=>"53716", "total"=>-90, "full_name"=>"Tom Tancredo", "party"=>"R"}], "status"=>"OK", "copyright"=>"Copyright (c) 2009 The New York Times Company.  All Rights Reserved."}
    HTTParty.stubs(:get).returns(@response)
  end
end
