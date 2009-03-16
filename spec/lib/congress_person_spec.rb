require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe CongressPerson do
  before do
    @legislator = fake_legislator
    @congress_person = CongressPerson.new(@legislator)
  end

  it "knows which attributes to display in the candidate summary" do
    @congress_person.should respond_to(:summary_attributes)
  end

  it "knows which attributes are currency values" do
    [:spent, :cash_on_hand, :total, :debt].each do |attribute|
      @congress_person.currency_attribute?(attribute).should be
    end
  end

  it "loads instance variables correctly" do
    CongressPerson::MAP.each do |key, value|
      @congress_person.should respond_to(key)
    end
  end

  it "loads a CandidateSummary" do
    stub_out_open_secrets_new
    summary = OpenSecrets::CandidateSummary.new('some id')
    OpenSecrets::CandidateSummary.expects(:new).with(@legislator.crp_id).returns(summary)
    CongressPerson.new(@legislator)
  end

  it "gets all the values from the CandidateSummary" do
    stub_out_open_secrets_new
    summary = OpenSecrets::CandidateSummary.new('some id')
    OpenSecrets::CandidateSummary.stubs(:new).returns(summary)
    congress_person = CongressPerson.new(@legislator)
    CongressPerson::CANDIDATE_SUMMARY_KEYS.each do |reader|
      congress_person.send(reader).should == summary.send(reader)
    end
  end

  it "knows when it has OpenSecrets data" do
    stub_out_open_secrets_new
    summary = OpenSecrets::CandidateSummary.new('some id')
    OpenSecrets::CandidateSummary.stubs(:new).returns(summary)
    CongressPerson.new(@legislator).has_candidate_summary?.should be_true
  end
  it "knows when it doesn't have OpenSecrets data" do
    @congress_person.has_candidate_summary?.should be_false
  end
end
