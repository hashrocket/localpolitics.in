module NewYorkTimes

  class Donor

    attr_reader :prefix, :first_name, :middle_name, :last_name, :suffix
    attr_reader :address1, :address2, :city, :state, :zip5

    def self.extract_donor_attributes(donation)
      donation.keys.grep(/^donor_/).inject({}) do |hash, key|
        value = donation[key]
        value = value.titleize if value && value.upcase == value
        hash.update(:"#{key[6..-1]}" => value)
      end
    end

    def self.top_by_zip(zip)
      donors = NewYorkTimes::CampaignFinance.donor_search_by_postal_code(zip)["results"] || []
      summarize_results(donors)
    end

    def self.summarize_results(results)
      donors = {}
      sum_hash = Hash.new(BigDecimal('0'))
      results.each do |donation|
        donor_attributes = extract_donor_attributes(donation)
        donor = (donors[donor_attributes.to_s] ||= new(donor_attributes))
        sum_hash[donor] += donation["donation_amount"]
      end

      sum_hash.sort {|a,b| a[1] <=> b[1] }.reverse
    end

    def initialize(donation)
      donation.each do |key, value|
        instance_variable_set("@#{key}", value) unless value == ""
      end
    end

    def name
      full_name = [prefix, first_name, middle_name, last_name, suffix].compact.join(" ")
      full_name.blank? ? nil : full_name
    end

    def address
      [address1, address2, "#{city}, #{state} #{zip5}"].compact.join("\n")
    end

    def to_s
      name || "Name unavailable"
    end

  end

end
