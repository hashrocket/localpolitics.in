require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LocalitiesController do
  before do
    @campaign_finance = stub_nytimes_finance
    @locality = Locality.new "53716"
    @locality.stubs(:has_district_data?).returns(true)
    Locality.stubs(:new).returns(@locality)
    @top_recipients = [{:name => 'name', :amount => '17', :rank => 1}]
    FedSpending.stubs(:top_recipients).returns(@top_recipients)
  end

  describe "routes" do
    it "allows locations with periods" do
      params_from(:get, "/Washington, D.C.").should == {:controller => "localities", :action => "show", :f_address => "Washington, D.C."}
    end
    it "allows locations without periods" do
      params_from(:get, "/53716").should == {:controller => "localities", :action => "show", :f_address => "53716"}
    end
  end

  describe "index action" do
    it "renders index if no query" do
      get :index
      response.should render_template(:index)
    end

    it "redirects if there's a query" do
      get :index, :f_address => "53716"
      response.should redirect_to(zip_path("53716"))
    end
  end

  describe "GET show" do
    def do_get
      get :show, :f_address => '53716'
    end
    it "initializes a locality if there's a query" do
      do_get
      assigns[:locality].should_not be_nil
    end

    it "sets the title" do
      controller.expects(:set_title).with("LocalPolitics.in/53716")
      do_get
    end

    it "gets donation totals by party" do
      @locality.stubs(:postal_code).returns('53716')
      @campaign_finance.expects(:totals_by_postal_code).with('53716').returns({:R => 15, :D => 16})
      do_get
    end

    it "stores the current location" do
      controller.expects(:set_location).with('53716')
      do_get
    end

    it "loads the top recipients of government spending" do
      FedSpending.expects(:top_recipients).returns(@top_recipients)
      do_get
    end

    it "loads a top_recipients instance variable" do
      do_get
      assigns[:top_recipients].should == @top_recipients
    end

    describe 'with an invalid zip code' do
      before do
        @locality = Locality.new "00000"
        @locality.stubs(:has_district_data?).returns(false)
        Locality.stubs(:new).returns(@locality)
      end
      def do_get
        get :show, :f_address => '00000'
      end
      it "renders the no district data error" do
        controller.expects(:render_no_district_data)
        do_get
      end
    end

    describe "render_no_district_data" do
      before do
        @locality.expects(:has_district_data?).raises(RCRest::CommunicationError, Exception.new('Broken xml from Google'))
      end
      it "renders the no district data error" do
        controller.expects(:render_no_district_data)
        do_get
      end
    end
  end
end

