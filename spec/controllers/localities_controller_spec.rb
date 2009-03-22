require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LocalitiesController do
  before do
    @campaign_finance = mock('campaign_finance')
    @campaign_finance.stubs(:party_totals_by_postal_code).with('53716').returns({:R => 15, :D => 16})
    NewYorkTimes::CampaignFinance.stubs(:new).returns(@campaign_finance)
  end
  describe "index action" do
    it "renders index if no query" do
      get :index
      response.should render_template(:index)
    end

    it "redirects if there's a query" do
      get :index, :q => "53716"
      response.should redirect_to(zip_path("53716"))
    end

    it "initializes a locality if there's a query" do
      get :show, :q => "53716"
      assigns[:locality].should_not be_nil
    end
  end

  describe "GET show" do
    def do_get
      get :show, :q => '53716'
    end

    it "sets the title" do
      controller.expects(:set_title).with("LocalPolitics.in/53716")
      do_get
    end

    it "gets donation totals by party" do
      @campaign_finance.expects(:party_totals_by_postal_code).with('53716').returns({:R => 15, :D => 16})
      do_get
    end

    it 'temporarily stores the zip code' do
      do_get
      flash[:zip_code].should == '53716'
    end
  end
end

