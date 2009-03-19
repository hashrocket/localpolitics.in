class LocalitiesController < ApplicationController
  def index
    unless params[:q].blank?
      redirect_to zip_path(params[:q])
    end
  end

  def show
    zip_code = params[:q]
    set_title("LocalPolitics.in/#{zip_code}")
    @locality = Locality.new zip_code
    @top_ten_donors = NewYorkTimes::Donor.top_by_zip(zip_code, 10) rescue nil
  end
end
