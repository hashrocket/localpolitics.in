class Data::Bioguide

  class << self
    def scrape_bioguide_site
      Legislator.all_where(:in_office => 1).each do |legislator|
        scrape_bioguide_page(legislator.bioguide_id)
      end
    end
    def scrape_bioguide_page(bioguide_id)
      url = construct_url(bioguide_id)
      document = Nokogiri::HTML(open(url))
      bio_text = document.at("p").text if document.at("p")
      if bio_text
        bio = Bio.find_or_create_by_bioguide_id_and_bio(bioguide_id, bio_text)
        bio.update_attribute(:bio, bio_text)
      end
    end

    def construct_url(bioguide_id)
      "http://bioguide.congress.gov/scripts/biodisplay.pl?index=#{bioguide_id}"
    end
  end
end
