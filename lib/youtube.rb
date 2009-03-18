class Youtube

  class << self
    def youtube_uploads_url_for(congress_person)
      return if congress_person.youtube_url.blank?
      user_name = congress_person.youtube_url.split('/').last
      "http://gdata.youtube.com/feeds/api/users/#{user_name}/uploads"
    end

    def most_recent(congress_person)
      xml = Nokogiri::HTML(open(youtube_uploads_url_for(congress_person)))
      element = xml.at("//feed/entry/group/content")
      element['url'] if element
    end
  end
end
