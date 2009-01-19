require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LocalitiesController do
  describe "index action" do
    it "renders index if no query" do
      get :index
      response.should render_template(:index)
    end

    it "renders show if there's a query" do
      get :index, :q => "12345"
      response.should render_template(:show)
    end
  end
end

