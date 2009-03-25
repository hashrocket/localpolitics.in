require 'pp'
module NewYorkTimes
  module CampaignFinance
    API_KEY = APP_CONFIG[:nyt_campaign_finance_api_key]

    class ZipSummary
      def initialize(attributes)
        @attributes = attributes
        @party_totals = {}
        @attributes["results"].each do |result|
          party = result["party"].to_sym
          @party_totals[party] ||= BigDecimal('0')
          @party_totals[party] += result["total"]
        end
      end

      def total_dollars
        @attributes["results"].sum {|result| BigDecimal(result["total"].to_s)}
      end

      def dollars_for(party)
        BigDecimal(@party_totals[party].to_s)
      end

      def lean_degree
        primary = dollars_for(lean_party)
        secondary = total_dollars - primary
        case
        when primary / 2 >= secondary then :heavy
        when primary > secondary      then :light
        else                               :wash
        end
      end

      def lean_party
        @party_totals.sort_by {|k,v| v}.last.first
      end

      def percentage_of_donations_for(party)
        dollars_for(party) / total_dollars
      end

      def [](attribute)
        case attribute
        when :D, :R then dollars_for(attribute)
        else             @attributes[attribute]
        end
      end
    end

    module_function

    # httparty 'http://api.nytimes.com/svc/elections/us/v2/president/2008/finances/contributions/donorsearch?zip=32250&api-key=434d438096f2f9dc0f9f3e5b972dde2c:19:25873066'
    def donor_search_by_postal_code(code)
      HTTParty.get("http://api.nytimes.com/svc/elections/us/v2/president/2008/finances/contributions/donorsearch?zip=#{code}&api-key=#{API_KEY}")
    end

    def url_for_totals_by_postal_code(code)
      "http://api.nytimes.com/svc/elections/us/v2/president/2008/finances/zips/#{code}?api-key=#{API_KEY}"
    end

    # httparty http://api.nytimes.com/svc/elections/us/v2/president/2008/finances/zips/32250?api-key=434d438096f2f9dc0f9f3e5b972dde2c:19:25873066
    def totals_by_postal_code(code)
      ZipSummary.new(HTTParty.get(url_for_totals_by_postal_code(code)))
    end

  end
end
