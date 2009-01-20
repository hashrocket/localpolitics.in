class LocalitiesController < ApplicationController
  def index
    unless params[:q].blank?
      redirect_to zip_path(params[:q])
    end
  end
  
  def show
    @locality = Locality.new params[:q]
  end
end
