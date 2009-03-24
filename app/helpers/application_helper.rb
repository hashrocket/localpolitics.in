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

  def youtube_embed(url)
    output = <<-YOUTUBES
      <object width="213" height="172">
        <param name="movie" value="#{url}"></param>
        <param name="allowFullScreen" value="true"></param>
        <embed src="#{url}" type="application/x-shockwave-flash" allowfullscreen="true" width="213" height="172"></embed>
      </object>
    YOUTUBES
  end

  def preferred_party_class(party_totals)
    democratic_dollars = party_totals[:D]
    republican_dollars = party_totals[:R]
    if democratic_dollars && republican_dollars
      return 'democrat is_a_wash' if democratic_dollars == republican_dollars
      return 'democrat leans_heavily_democratic' if (democratic_dollars / 2) >= republican_dollars
      return 'republican leans_heavily_republican' if (republican_dollars / 2) >= democratic_dollars
      return 'democrat leans_democratic' if democratic_dollars > republican_dollars
      return 'republican leans_republican' if republican_dollars > democratic_dollars
    else
      return 'democrat is_a_wash' if democratic_dollars.blank? && republican_dollars.blank?
      return 'democrat leans_heavily_democratic' if republican_dollars.blank?
      return 'republican leans_heavily_republican' if democratic_dollars.blank?
    end
  end

  def preferred_party_text(party_totals)
    democratic_dollars = party_totals[:D]
    republican_dollars = party_totals[:R]
    total_dollars      = party_totals[:D] + party_totals[:R] if democratic_dollars && republican_dollars
    democratic_percent = if democratic_dollars && republican_dollars
                           number_to_percentage(democratic_dollars / total_dollars * 100, :precision => 1)
                         else
                           number_to_percentage(democratic_dollars ? 100 : 0, :precision => 1)
                         end
    republican_percent = if democratic_dollars && republican_dollars
                           number_to_percentage(republican_dollars / total_dollars * 100, :precision => 1)
                         else
                           number_to_percentage(republican_dollars ? 0 : 100, :precision => 1)
                         end
    case preferred_party_class(party_totals)
    when 'democrat leans_heavily_democratic'
      "Get out your Birkenstocks! #{democratic_percent} of all donations in your zip code were to Democrats."
    when 'republican leans_heavily_republican'
      "Your zip code gives a ton of money to Republicans - #{republican_percent} of all donations."
    when 'democrat leans_democratic'
      "Your zip code leans Democratic - they received #{democratic_percent} of all donations."
    when 'republican leans_republican'
      "Your zip code leans Republican - they received #{republican_percent} of all donations."
    else
      "Your zip code donates exactly half and half!  How egalitarian of you."
    end
  end

  def can_invite_to_twitter?(crp_id)
    return true unless cookies[:twitter_invites] && cookies[:twitter_invites] =~ /#{crp_id}/
    return false
  end
end
