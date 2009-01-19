class CongressPerson
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
          "congresspedia_url" => "congresspedia_url"
        }

  PARTIES = { "R" => "Republican",
              "D" => "Democrat",
              "I" => "Independent",
              "L" => "Libertarian" }

  MAP.keys.each do |name|
    attr_reader name
  end

  def initialize(legislator)
    MAP.each do |name, attribute|
      val = legislator.send(attribute)
      instance_variable_set("@#{name}", val)
    end
  end

  def full_name
    first_name + " " + last_name
  end

  def party
    PARTIES[@party] || @party
  end

  def photo_path
    "/congresspeople/#{photo_id}.jpg"
  end
end

