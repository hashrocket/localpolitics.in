class LocalitiesController < ApplicationController
  def index
    unless params[:f_address].blank?
      redirect_to zip_path(params[:f_address])
    end
  end

  def show
    location = params[:f_address]
    flash[:zip_code] = location
    set_title("LocalPolitics.in/#{location}")
    @locality = Locality.new location
    if @locality.has_district_data?
      if @locality.postal_code
        @top_ten_donors = NewYorkTimes::Donor.top_by_zip(@locality.postal_code, 10)
        @party_totals = NewYorkTimes::CampaignFinance.party_totals_by_postal_code(@locality.postal_code)
        @top_recipients = FedSpending.top_recipients(:zip_code => @locality.postal_code)
      end
    else
      flash[:error] = "We could not find data for your zip code. If you feel this is an error, contact us at the link below."
      redirect_to(root_path)
    end
  end
end
