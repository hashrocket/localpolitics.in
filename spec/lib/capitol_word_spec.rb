require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')

describe CapitolWord do

  before do
    @congress_person = CongressPerson.new(fake_legislator)
  end

  describe "construct_url" do
    describe "when getting the latest day's words for a lawmaker" do
      subject do
        CapitolWord.construct_url(@congress_person, "lawmaker", "latest", :results => 5)
      end
      it "includes the congress person's bioguide id" do
        should include(@congress_person.bioguide_id)
      end
      it "includes the number of results" do
        should include("5")
      end
      it "includes the namespace" do
        should include("lawmaker")
      end
      it "includes the method name" do
        should match(/latest\/top\d+\.json/)
      end
    end
  end

  describe "latest_for" do
    before do
      HTTParty.stubs(:get).returns(latest_words_response)
    end
    it "returns a collection of CapitolWords" do
      CapitolWord.latest_for(@congress_person).all? {|cw| cw.kind_of? CapitolWord }.should be_true
    end
  end

  def latest_words_response
    [{"word" => "farmers", "word_count" => 21}, {"word" => "agriculture", "word_count" => 18}, {"word" => "dairy", "word_count" => 17}, {"word" => "farm", "word_count" => 13}, {"word" => "milk", "word_count" => 11}]
  end

end
