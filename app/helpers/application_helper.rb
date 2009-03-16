# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def twitter_url_for(representative)
    "http://twitter.com/#{representative.twitter_id}"
  end

  def twitter_link_for(representative)
    unless representative.twitter_id.blank?
      link_to "Follow On Twitter", twitter_url_for(representative)
    end
  end
end
