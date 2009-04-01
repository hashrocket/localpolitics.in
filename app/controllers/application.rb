# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '8fde19bfc9b4608247e3e7b8b0f29803'

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  # filter_parameter_logging :password

  rescue_from "ActionController::RoutingError" do |exception|
    flash.keep # don't let a routing error reset your flash
    raise exception
  end

  rescue_from Sunlight::Error do |exception|
    flash[:error] = "We could not find data for your zip code. If you feel this is an error, contact us at the link below."
    redirect_to(root_path)
  end

  def set_title(title)
    @title = title
  end

  def set_location(location)
    session[:location] = location
  end
end
