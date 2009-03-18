# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def twitter_url_for(representative)
    "http://twitter.com/#{representative.twitter_id}"
  end

  def twitter_link_for(representative, link_text = "Follow On Twitter")
    unless representative.twitter_id.blank?
      link_to link_text, twitter_url_for(representative)
    end
  end

  def title_and_full_name_for(representative)
    "#{representative.title} #{representative.full_name}"
  end

  def govtrack_photo(representative, options={:size => '200'})
    url = "/govtrack/photos/#{representative.govtrack_id}"
    url += "-#{options[:size]}px" if options[:size]
    url += ".jpeg"
    url = "/govtrack/photos/no_picture.jpeg" unless File.exists?(RAILS_ROOT + "/public" + url)
    image_tag(url, :alt => "Photo of #{representative.full_name}")
  end
end
