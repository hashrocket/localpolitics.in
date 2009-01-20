require 'pp'
module NewYorkTimes
  class CampaignFinance
    API_KEY = '434d438096f2f9dc0f9f3e5b972dde2c:19:25873066'

    # httparty 'http://api.nytimes.com/svc/elections/us/v2/president/2008/finances/contributions/donorsearch?zip=32250&api-key=434d438096f2f9dc0f9f3e5b972dde2c:19:25873066'
    def donor_search_by_postal_code(code)
      HTTParty.get("http://api.nytimes.com/svc/elections/us/v2/president/2008/finances/contributions/donorsearch?zip=#{code}&api-key=#{API_KEY}")
    end

    # httparty http://api.nytimes.com/svc/elections/us/v2/president/2008/finances/zips/32250?api-key=434d438096f2f9dc0f9f3e5b972dde2c:19:25873066
    def totals_by_postal_code(code)
      HTTParty.get("http://api.nytimes.com/svc/elections/us/v2/president/2008/finances/zips/#{code}?api-key=#{API_KEY}")
    end
  end
end
