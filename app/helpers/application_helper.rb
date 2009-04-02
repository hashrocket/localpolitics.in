# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def twitter_url_for(representative)
    "http://twitter.com/#{representative.twitter_id}"
  end

  def twitter_link_for(representative, link_text = "Follow On Twitter")
    if representative.twitters?
      link_to link_text, twitter_url_for(representative)
    end
  end

  def title_and_full_name_for(representative)
    "#{representative.title} #{representative.full_name}"
  end

  def govtrack_photo(representative, options={:size => '200'})
    url = representative.govtrack_photo
    image_tag(url, :alt => "Photo of #{representative.full_name}")
  end

  def youtube_embed(url)
    output = <<-YOUTUBES
      <object width="213" height="172">
        <param name="movie" value="#{url}"></param>
        <param name="allowFullScreen" value="true"></param>
        <param name="wmode" value="transparent"></param>
        <embed src="#{url}" type="application/x-shockwave-flash" wmode="transparent" allowfullscreen="true" width="213" height="172"></embed>
      </object>
    YOUTUBES
  end

  def preferred_party_class(party_totals)
    party = case party_totals.lean_party
    when :D then "democrat"
    when :R then "republican"
    else party_totals.lean_party.to_s
    end

    party + " " << case party_totals.lean_degree
    when :heavy then "leans_heavily"
    when :light then "leans_lightly"
    when :wash  then "is_a_wash"
    end
  end

  def preferred_party_text(party_totals)
    percentage = number_to_percentage(party_totals.percentage_of_donations_for(party_totals.lean_party) * 100, :precision => 1)
    case [party_totals.lean_party, party_totals.lean_degree]
    when [:D, :heavy]
      "Get out your Birkenstocks! #{percentage} of all donations in your zip code were to Democrats."
    when [:D, :light]
      "Your zip code leans Democratic - they received #{percentage} of all donations."
    when [:R, :heavy]
      "Your zip code gives a ton of money to Republicans - #{percentage} of all donations."
    when [:R, :light]
      "Your zip code leans Republican - they received #{percentage} of all donations."
    else
      "Your zip code donates exactly half and half!  How egalitarian of you."
    end
  end

  def can_invite_to_twitter?(crp_id)
    return true unless cookies[:twitter_invites] && cookies[:twitter_invites] =~ /#{crp_id}/
    return false
  end

  def lucky_link_to(text, search_term = text, options = {})
    search_term, options = text, search_term if search_term.kind_of?(Hash)
    options = options.dup
    options[:class] = [options[:class], "lucky"].compact.flatten.join(" ")
    link_to text,"http://www.google.com/search?btnI=1&q=#{url_encode(search_term)}", options
  end

  def capitol_words_url_for(congress_person)
    "http://www.capitolwords.org/lawmaker/#{congress_person.bioguide_id}"
  end

  def current_location
    session[:location]
  end

  def link_to_locality_page
    if current_location
      link_to 'Back to Your District', zip_path(current_location)
    end
  end
end
