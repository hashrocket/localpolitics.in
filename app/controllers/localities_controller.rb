class LocalitiesController < ApplicationController
  def index
    unless params[:q].blank?
      render :action => 'show'
    end
  end
end
