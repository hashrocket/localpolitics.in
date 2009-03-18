require File.dirname(__FILE__) + "/../spec_helper.rb"

describe Tweet do

  describe ".status_url" do
    it "returns the correct url" do
      Tweet.status_url_for('veezus').should == "http://twitter.com/statuses/user_timeline/veezus.xml?count=5"
    end
    it "includes the count parameter" do
      Tweet.status_url_for('veezus', 10).should include("?count=10")
    end
  end

  describe ".recent" do
    before do
      Tweet.stubs(:status_url_for).returns(File.join(RAILS_ROOT + '/spec/fixtures/RussFeingold.xml'))
    end
    it "returns an array of tweets" do
      Tweet.recent('veezus').all?{|t| t.kind_of? Tweet}.should be_true
    end
  end

  describe "included data" do
    before do
      @utc_time = Time.now.utc
      @tweet = Tweet.new(:text => "I love twittering!", :created_at => @utc_time)
    end
    it "includes the text" do
      @tweet.text.should == "I love twittering!"
    end
    it "includes the date" do
      @tweet.created_at.should == @utc_time
    end
  end
end
