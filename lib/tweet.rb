class Tweet
  class << self
    def status_url_for(twitter_id, count=5)
      "http://twitter.com/statuses/user_timeline/#{twitter_id}.xml?count=#{count}"
    end

    def recent(twitter_id, count=5)
      xml = Nokogiri::XML(open(status_url_for(twitter_id, count)))
      tweets = []
      xml.search('statuses/status').each do |tweet|
        tweets << Tweet.new(:text => tweet.at('text').text, :created_at => tweet.at('created_at').text)
      end
      tweets
    end

    def invitation_text
      <<-TEXT
      Twitter is a service for friends, family, co–workers, and public figures to communicate and stay connected through the exchange of quick, frequent answers to one simple question: What are you doing? Even basic updates are meaningful and provide your constituents with a way to stay informed of the work you are doing.

      Sign up for twitter: http://twitter.com
      TEXT

    end
  end

  attr_accessor :text, :created_at

  def initialize(params)
    @text = params[:text]
    @created_at = params[:created_at]
  end
end
