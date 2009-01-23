module NewYorkTimes

  class CongressAPI
    include HTTParty

    API_KEY = APP_CONFIG[:nyt_congress_api_key]
  end

end
