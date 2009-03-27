require 'timeout'

class CongressPerson

  # Maps our attributes to Sunlight API's (for now)
  MAP = { "first_name"        => "firstname",
          "last_name"         => "lastname",
          "party"             => "party",
          "state"             => "state",
          "office_address"    => "congress_office",
          "phone_number"      => "phone",
          "fax_number"        => "fax",
          "email_address"     => "email",
          "website_url"       => "website",
          "twitter_id"        => "twitter_id",
          "contact_form_url"  => "webform",
          "photo_id"          => "bioguide_id",
          "congresspedia_url" => "congresspedia_url",
          "state_machine_id"  => "fec_id",
          "district"          => "district",
          "title"             => "title",
          "govtrack_id"       => "govtrack_id",
          "crp_id"            => "crp_id",
          "youtube_url"       => "youtube_url"
        }

  PARTIES = { "R" => "Republican",
              "D" => "Democrat",
              "I" => "Independent",
              "L" => "Libertarian" }

  TITLES = { "Rep" => "Representative",
             "Sen" => "Senator"}

  # Used to look up campaign contributors
  SM_BASE_URL = "http://data.state-machine.org/candidates/:state_machine_id.xml"

  CANDIDATE_SUMMARY_KEYS = OpenSecrets::CandidateSummary::READERS - CongressPerson::MAP.symbolize_keys.keys
  attr_reader *CANDIDATE_SUMMARY_KEYS

  def initialize(legislator)
    MAP.each do |name, attribute|
      val = legislator.send(attribute)
      instance_variable_set("@#{name}", val)
    end
    summary = Rails.cache.fetch("opensecrets/#@crp_id", :expires_in => 1.hour) do
      OpenSecrets::CandidateSummary.new(@crp_id)
    end
    OpenSecrets::CandidateSummary::READERS.each do |reader|
      instance_variable_set("@#{reader}", summary.send(reader)) unless instance_variable_get("@#{reader}")
    end
  end

  def self.find(options)
    CongressPerson.new(Sunlight::Legislator.where(options))
  end

  def self.find_all_by_govtrack_id(ids)
    params = ids.map{|id| {:govtrack_id => id} }
    legislators = Sunlight::Legislator.all_where(params)
    congress_people = []
    legislators.each do |l|
      congress_people << CongressPerson.new(l)
    end
    congress_people
  end

  def introduced_bills
    Bill.find_all_by_sponsor_id(govtrack_id)
  end

  def has_introduced_bills?
    introduced_bills.any?
  end

  def sponsored_bills
    Bill.find(:all, :conditions => ["cosponsor_ids LIKE ?", "%#{govtrack_id}%"])
  end

  def has_sponsored_bills?
    sponsored_bills.any?
  end

  def can_has_youtubes?
    !youtube_url.blank?
  end

  def committees
    CommitteeMembership.find_all_by_govtrack_id(govtrack_id).map(&:committee)
  end

  def has_committees?
    !committees.empty?
  end

  def tweets
    Tweet.recent(twitter_id)# if twitters?
  end

  def twitters?
    !twitter_id.blank?
  end

  def bio_text
    if bio = Bio.find_by_bioguide_id(bioguide_id)
      bio.bio
    end
  end

  def has_bio_text?
    !bio_text.nil?
  end

  def summary_attributes
    CANDIDATE_SUMMARY_KEYS - [:cand_name, :chamber, :cid, :cycle, :last_updated, :origin, :source]
  end

  def currency_attribute?(attribute)
    [:spent, :cash_on_hand, :total, :debt].include?(attribute)
  end

  def has_candidate_summary?
    CANDIDATE_SUMMARY_KEYS.any?{|r| !self.send(r).blank? }
  end

  def senator?
    title == "Senator"
  end

  def full_name
    first_name + " " + last_name
  end

  def party
    PARTIES[@party] || @party
  end

  def title
    TITLES[@title] || @title
  end

  def has_photo?
    !photo_id.blank? && File.exists?(File.join(RAILS_ROOT, "public", photo_path))
  end

  def photo
    has_photo? ? photo_path : default_photo_path
  end

  def photo_path
    "/images/congresspeople/#{photo_id}.jpg"
  end

  def default_photo_path
    "/images/no_picture.jpg"
  end

  def latest_words(options={})
    CapitolWord.latest_for(self, options)
  end

  def bioguide_id
    photo_id
  end

  def has_open_congress_id?
    !crp_id.blank?
  end

  # Returns an array of Arrays, largest contribution to smallest:
  # [["Name", "5000"], ["Other Name", "550"]]
  def top_contributors(qty = 10)
    contributors.sort_by do |contributor, amount|
      amount.to_i
    end.reverse.first(qty)
  end

  def contributors
    return @contributors if @contributors
    @contributors = {}
    doc = Nokogiri::XML(contributions_data)

    doc.search('contribution').each do |e|
      name  = e.attributes["name"].content.titleize
      total = e.attributes["total"].content
      @contributors[name] = total
    end

    @contributors
  end

  def contributions_data
    begin
      Timeout.timeout(10) do
        open(contributions_url)
      end
    rescue OpenURI::HTTPError, Timeout::Error
      "<xml></xml>"
    end
  end

  def contributions_url
    SM_BASE_URL.sub(/:state_machine_id/, state_machine_id)
  end

  # Create readers for each API attribute, unless they are already defined
  MAP.keys.each do |name|
    attr_reader name unless instance_methods.include?(name)
  end
end

