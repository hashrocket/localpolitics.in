module Sunlight

  class Legislator < SunlightObject


    attr_accessor :title, :firstname, :middlename, :lastname, :name_suffix, :nickname,
                  :party, :state, :district, :gender, :phone, :fax, :website, :webform,
                  :email, :congress_office, :bioguide_id, :votesmart_id, :fec_id,
                  :govtrack_id, :crp_id, :event_id, :congresspedia_url, :twitter_id, :youtube_url

    # Takes in a hash where the keys are strings (the format passed in by the JSON parser)
    #
    def initialize(params)
      params.each do |key, value|
        instance_variable_set("@#{key}", value) if respond_to?(key)
      end
    end



    #
    # Useful for getting the exact Legislators for a given district.
    #
    # Returns:
    #
    # A Hash of the three Members of Congress for a given District: Two
    # Senators and one Representative.
    #
    # You can pass in lat/long or address. The district will be
    # determined for you:
    #
    #   officials = Legislator.all_for(:latitude => 33.876145, :longitude => -84.453789)
    #   senior = officials[:senior_senator]
    #   junior = officials[:junior_senator]
    #   rep = officials[:representative]
    #
    #   Legislator.all_for(:address => "123 Fifth Ave New York, NY 10003")
    #   Legislator.all_for(:address => "90210") # not recommended, but it'll work
    #
    def self.all_for(params)
      if params[:latitude] && params[:longitude]
        district = District.get(:latitude => params[:latitude], :longitude => params[:longitude])
      elsif params[:address]
        district = District.get(:address => params[:address])
      end
      all_in_district(district)
    end


    def self.all_for_zip(zip)
      url = construct_url("legislators.allForZip", :zip => zip)
      Rails.cache.fetch(url, :expires_in => 1.hour) do
        HTTParty.get(url)
      end["response"]["legislators"]
    end


    #
    # A helper method for all_for. Use that instead, unless you
    # already have the district object, then use this.
    #
    # Usage:
    #
    #   officials = Legislator.all_in_district(District.new("NJ", "7"))
    #
    def self.all_in_district(district)
      senior_senator = all_where(:state => district.state, :district => "Senior Seat").first
      junior_senator = all_where(:state => district.state, :district => "Junior Seat").first
      representative = all_where(:state => district.state, :district => district.number).first

      {:senior_senator => senior_senator, :junior_senator => junior_senator, :representative => representative}

    end

    def self.get_cached_json_data(url)
      Rails.cache.fetch(url, :expires_in => 1.hour) do
        get_json_data(url)
      end
    end

    #
    # A more general, open-ended search on Legislators than #all_for.
    # See the Sunlight API for list of conditions and values:
    #
    # http://services.sunlightlabs.com/api/docs/legislators/
    #
    # Returns:
    #
    # An array of Legislator objects that matches the conditions
    #
    # Usage:
    #
    #   johns = Legislator.all_where(:firstname => "John")
    #   floridians = Legislator.all_where(:state => "FL")
    #   dudes = Legislator.all_where(:gender => "M")
    #
    def self.all_where(params)
      url = construct_url("legislators.getList", params)
      if result = get_cached_json_data(url)
        result["response"]["legislators"].map do |legislator|
          new(legislator["legislator"])
        end
      end
    end

    def self.where(params)
      url = construct_url("legislators.get", params)
      if result = get_cached_json_data(url)
        new(result["response"]["legislator"])
      end
    end



  end # class Legislator

end # module Sunlight
