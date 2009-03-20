require 'pp'
module NewYorkTimes
  class CampaignFinance
    API_KEY = APP_CONFIG[:nyt_campaign_finance_api_key]

    # httparty 'http://api.nytimes.com/svc/elections/us/v2/president/2008/finances/contributions/donorsearch?zip=32250&api-key=434d438096f2f9dc0f9f3e5b972dde2c:19:25873066'
    def donor_search_by_postal_code(code)
      HTTParty.get("http://api.nytimes.com/svc/elections/us/v2/president/2008/finances/contributions/donorsearch?zip=#{code}&api-key=#{API_KEY}")
    end

    # httparty http://api.nytimes.com/svc/elections/us/v2/president/2008/finances/zips/32250?api-key=434d438096f2f9dc0f9f3e5b972dde2c:19:25873066
    def totals_by_postal_code(code)
      HTTParty.get(url_for_totals_by_postal_code(code))
    end

    def url_for_totals_by_postal_code(code)
      "http://api.nytimes.com/svc/elections/us/v2/president/2008/finances/zips/#{code}?api-key=#{API_KEY}"
    end

    def party_totals_by_postal_code(code)
      party_totals = {}
      results = totals_by_postal_code(code)
      results["results"].each do |result|
        party = result["party"].to_sym
        party_totals[party] = 0 unless party_totals[party]
        party_totals[party] += result["total"]
      end
      party_totals
    end
  end
end
