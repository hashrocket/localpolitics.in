require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Data::Govtrack do
  describe "bills_location_for" do
    it "should know where the bills data is kept" do
      Data::Govtrack.bills_location_for('110').should == RAILS_ROOT + "/public/govtrack/110_bills/"
    end
  end

  describe "import_bills" do
    before do
      Data::Govtrack.stubs(:bills_location_for).returns('bills_location/')
      Dir.stubs(:new).returns(['file_name.xml'])
    end
    it "calls bills_location_for" do
      Data::Govtrack.expects(:bills_location_for).returns('bills_location/')
      Data::Govtrack.stubs(:import_bill)
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
end

