require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LocalitiesController do
  describe "index action" do
    it "renders index if no query" do
      get :index
      response.should render_template(:index)
    end

    it "redirects if there's a query" do
      get :index, :q => "12345"
      response.should redirect_to(zip_path("12345"))
    end
    
    it "initializes a locality if there's a query" do
      get :show, :q => "12345"
      assigns[:locality].should_not be_nil
    end
  end
end

