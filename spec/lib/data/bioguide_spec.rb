require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Data::Bioguide do
  before do
    stub_out_open_secrets_new
    @congress_person = CongressPerson.new(fake_legislator)
  end

  describe "with stubbed out construct_url" do
    before do
      Data::Bioguide.stubs(:construct_url).returns(File.join(RAILS_ROOT + '/spec/fixtures/bioguide_sample.html'))
    end

    describe "scrape_bioguide_site" do
      it "gets all legislators" do
        Sunlight::Legislator.expects(:all_where).with({:in_office => 1}).returns([fake_legislator])
        Data::Bioguide.scrape_bioguide_site
      end
      it "scrapes the bioguide page for each legislator" do
        Sunlight::Legislator.stubs(:all_where).returns([fake_legislator])
        Data::Bioguide.expects(:scrape_bioguide_page).with(fake_legislator.bioguide_id)
        Data::Bioguide.scrape_bioguide_site
      end
    end

    describe "scrape_bioguide_page" do
      it "gets the bioguide url" do
        Data::Bioguide.expects(:construct_url).returns(File.join(RAILS_ROOT + '/spec/fixtures/bioguide_sample.html'))
        Data::Bioguide.scrape_bioguide_page(@congress_person.bioguide_id)
      end
      it "creates a Bio" do
        Bio.expects(:find_or_create_by_bioguide_id_and_bio).returns(Bio.new)
        Data::Bioguide.scrape_bioguide_page(@congress_person.bioguide_id)
      end
      it "correctly assigns the bio attribute" do
        Data::Bioguide.scrape_bioguide_page(@congress_person.bioguide_id)
        bio = Bio.find_by_bioguide_id(@congress_person.bioguide_id)
        bio.should_not be_nil
        bio.bio.should include("FEINGOLD")
      end
    end
  end

  describe ".construct_url" do
    it "builds a bioguide url given a bioguide_id" do
      Data::Bioguide.construct_url(@congress_person.bioguide_id).should == "http://bioguide.congress.gov/scripts/biodisplay.pl?index=#{@congress_person.bioguide_id}"
    end
  end

end
