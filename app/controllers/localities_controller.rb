class LocalitiesController < ApplicationController
  def index
    unless params[:q].blank?
      redirect_to zip_path(params[:q])
    end
  end
  
  def show
    @locality = Locality.new params[:q]
    @top_ten_donors = NewYorkTimes::Donor.top_by_zip(params[:q], 10) rescue nil
  end
end
