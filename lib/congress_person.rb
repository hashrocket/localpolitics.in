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
          "contact_form_url"  => "webform",
          "photo_id"          => "bioguide_id",
          "congresspedia_url" => "congresspedia_url",
          "state_machine_id"  => "fec_id",
          "district"          => "district",
          "title"             => "title",
          "govtrack_id"       => "govtrack_id",
          "crp_id"            => "crp_id"
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

  def summary_attributes
    CANDIDATE_SUMMARY_KEYS - [:cand_name, :chamber, :cid, :cycle, :last_updated, :origin, :source]
  end

  def currency_attribute?(attribute)
    [:spent, :cash_on_hand, :total, :debt].include?(attribute)
  end

  def initialize(legislator)
    MAP.each do |name, attribute|
      val = legislator.send(attribute)
      instance_variable_set("@#{name}", val)
    end
    summary = OpenSecrets::CandidateSummary.new(@crp_id)
    OpenSecrets::CandidateSummary::READERS.each do |reader|
      instance_variable_set("@#{reader}", summary.send(reader)) unless instance_variable_get("@#{reader}")
    end
  end

  def has_candidate_summary?
    CANDIDATE_SUMMARY_KEYS.any?{|r| !self.send(r).blank? }
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

  def photo_path
    "/images/congresspeople/#{photo_id}.jpg"
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

