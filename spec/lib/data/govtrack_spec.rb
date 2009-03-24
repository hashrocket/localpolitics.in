require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Data::Govtrack do
  describe "bills_location_for" do
    it "should know where the bills data is kept" do
      Data::Govtrack.bills_location_for('110').should == RAILS_ROOT + "/public/govtrack/110_bills/"
    end
  end

  describe "map_bill_type" do
    it "sets 'h' to 'h.r.'" do
      Data::Govtrack.map_bill_type('h').should == 'h.r.'
    end
    it "sets 'hr' to 'h.res.'" do
      Data::Govtrack.map_bill_type('hr').should == 'h.res.'
    end
    it "sets 'hc' to 'h.con.res.'" do
      Data::Govtrack.map_bill_type('hc').should == 'h.con.res.'
    end
    it "sets 'hj' to 'h.j.res.'" do
      Data::Govtrack.map_bill_type('hj').should == 'h.j.res.'
    end
    it "sets 's' to 's.'" do
      Data::Govtrack.map_bill_type('s').should == 's.'
    end
    it "sets 'sr' to 's.res.'" do
      Data::Govtrack.map_bill_type('sr').should == 's.res.'
    end
    it "sets 'sc' to 's.con.res.'" do
      Data::Govtrack.map_bill_type('sc').should == 's.con.res.'
    end
    it "sets 'sj' to 's.j.res.'" do
      Data::Govtrack.map_bill_type('sj').should == 's.j.res.'
    end
  end

  describe "pad_number" do
    it "adds leading zeros to make a 5 character string" do
      Data::Govtrack.pad_number("7").should == "00007"
    end
  end

  describe "import_bills" do
    before do
      Data::Govtrack.stubs(:bills_location_for).returns('bills_location/')
      Dir.stubs(:new).returns(['file_name.xml'])
      Data::Govtrack.stubs(:import_bill)
      Bill.stubs(:delete_all)
    end
    it "destroys existing bills for this session" do
      Bill.expects(:delete_all).with('session = 110')
      Data::Govtrack.import_bills('110')
    end
    it "calls bills_location_for" do
      Data::Govtrack.expects(:bills_location_for).returns('bills_location/')
      Data::Govtrack.import_bills('110')
    end
    it "finds all xml files in the directory" do
      Data::Govtrack.expects(:import_bill).with('bills_location/file_name.xml')
      Data::Govtrack.import_bills('110')
    end
  end

  describe "import_bill" do
    before do
      @bill = Bill.new
      Bill.stubs(:new).returns(@bill)
    end

    describe "with complete xml" do
      before do
        @xml = <<-XML
          <bill session="110" type="h" number="1000" updated="2009-01-08T18:55:13-05:00">
            <status><introduced date="1171256400" datetime="2007-02-12"/></status>

            <introduced date="1171256400" datetime="2007-02-12"/>
            <titles>
                    <title type="short" as="introduced">Edward William Brooke III Congressional Gold Medal Act</title>
                    <title type="official" as="introduced">To award a congressional gold medal to Edward William Brooke III in recognition of his unprecedented and enduring service to our Nation.</title>
            </titles>
            <sponsor id="400295"/>
            <cosponsors>
                    <cosponsor id="400290" joined="2007-06-21"/>
                    <cosponsor id="400291" joined="2007-06-21"/>
            </cosponsors>
            <summary>
              2/12/2007--Introduced.<br/>Edward William Brooke III Congressional Gold Medal Act - Awards a congressional gold medal to Edward William Brooke III, the first African American elected by popular vote to the U.S. Senate, in recognition of his unprecedented and enduring service to our Nation.<br/>
              </summary>
          </bill>
        XML
        File.stubs(:read).returns(@xml)
      end

      it "sets the bill's title" do
        @bill.expects(:title=).with("Edward William Brooke III Congressional Gold Medal Act")
        Data::Govtrack.import_bill("some location")
      end
      it "sets the bill's description" do
        @bill.expects(:description=).with("To award a congressional gold medal to Edward William Brooke III in recognition of his unprecedented and enduring service to our Nation.")
        Data::Govtrack.import_bill("some location")
      end
      it "sets the bill's summary" do
        @bill.expects(:summary=)
        Data::Govtrack.import_bill("some location")
      end
      it "sets the bill's sponsor_id" do
        @bill.expects(:sponsor_id=).with("400295")
        Data::Govtrack.import_bill("some location")
      end
      it "sets the bill's cosponsor_ids" do
        @bill.expects(:cosponsor_ids=).with(["400290", "400291"])
        Data::Govtrack.import_bill("some location")
      end
      it "sets the bill's session" do
        @bill.expects(:session=).with(110)
        Data::Govtrack.import_bill("some location")
      end
      it "sets the bill's type" do
        @bill.expects(:bill_type=).with("h.r.")
        Data::Govtrack.import_bill("some location")
      end
      it "sets the bill's number" do
        @bill.expects(:number=).with("01000")
        Data::Govtrack.import_bill("some location")
      end
      it "maps the bill's type to a thomas.gov search-compatible type" do
        Data::Govtrack.expects(:map_bill_type).with("h").returns("h.r.")
        Data::Govtrack.import_bill("some location")
      end
      it "pads the bill's number with leading zeroes" do
        Data::Govtrack.expects(:pad_number).with("1000").returns("00074")
        Data::Govtrack.import_bill("some location")
      end
      it "saves the new bill" do
        @bill.expects(:save)
        Data::Govtrack.import_bill("some location")
      end
    end

    describe "with incomplete xml" do
      before do
        @incomplete_xml = <<-XML
          <bill session="110" type="h" number="1000" updated="2009-01-08T18:55:13-05:00">
            <status><introduced date="1171256400" datetime="2007-02-12"/></status>

            <introduced date="1171256400" datetime="2007-02-12"/>
            <titles>
                    <title type="short" as="introduced">Edward William Brooke III Congressional Gold Medal Act</title>
            </titles>
            <sponsor id="400295"/>
            <cosponsors>
            </cosponsors>
          </bill>
        XML
        File.stubs(:read).returns(@incomplete_xml)
      end
      it "doesn't raise an error" do
        lambda {Data::Govtrack.import_bill("some location")}.should_not raise_error
      end
    end
  end

  describe "import_committee_memberships" do
    before do
      @xml = <<-XML
        <?xml version="1.0" ?>
        <people>
          <person id='400001' lastname='Abercrombie' firstname='Neil' birthday='1938-06-26' gender='M' osid='N00007665' bioguideid='A000014' metavidid='Neil_Abercrombie' title='Rep.' state='HI' district='1' name='Rep. Neil Abercrombie [D, HI-1]' >
          <current-committee-assignment committee='House Armed Services' />
          </person>
        </people>
      XML
      File.stubs(:read).returns(@xml)
    end
    it "calls persist_committee_membership for each committee membership" do
      Data::Govtrack.expects(:persist_committee_membership).with('House Armed Services', '400001')
      Data::Govtrack.import_committee_memberships
    end
  end

  describe "persist_committee_membership" do
    before do
      @committee = Factory(:committee)
      @committee.committee_memberships.stubs(:exists?)
      Committee.stubs(:find_or_create_by_name).with(@committee.name).returns(@committee)
      @congress_person = CongressPerson.new(fake_legislator)
    end
    it "creates the CommitteeMembership with the correct govtrack_id if it doesn't exist" do
      @committee.committee_memberships.stubs(:exists?).returns(false)
      @committee.committee_memberships.expects(:create).with({:govtrack_id => '300042'})
      Data::Govtrack.persist_committee_membership(@committee.name, '300042')
    end
    it "doesn't create a new CommitteeMembership with the correct govtrack_id if it exists" do
      @committee.committee_memberships.stubs(:exists?).returns(true)
      @committee.committee_memberships.expects(:create).with({:govtrack_id => @congress_person.govtrack_id}).never
      Data::Govtrack.persist_committee_membership(@committee.name, '300042')
    end
    it "finds or creates a Committee" do
      Committee.expects(:find_or_create_by_name).with(@committee.name).returns(@committee)
      Data::Govtrack.persist_committee_membership(@committee.name, '300042')
    end
  end

end

