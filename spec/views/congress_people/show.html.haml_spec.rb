require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe "CongressPerson show view" do

  before do
    @legislator = fake_legislator
    @congress_person = CongressPerson.new(@legislator)
    @congress_person.stubs(:twitters?).returns(false)
    @congress_person.stubs(:can_has_youtubes?).returns(false)
    @congress_person.stubs(:latest_words).returns([CapitolWord.new("word" => "word", "word_count" => 12)])
    assigns[:congress_person] = @congress_person
    assigns[:tweet_time] = Time.now
    @tweets = [Tweet.new(:text => 'tweet', :created_at => Time.now.utc)]
  end

  def do_render
    render "/congress_people/show.html.haml"
  end

  it "should list the congress person" do
    do_render
    response.body.should include(@congress_person.full_name)
  end
  it "should include a photo" do
    template.stubs(:govtrack_photo).returns("<img src='/govtrack/photos/#{@congress_person.govtrack_id}.jpeg'/>")
    do_render
    response.should have_tag("img[src=?]", "/govtrack/photos/#{@congress_person.govtrack_id}.jpeg")
  end
  it "should link to the congress person's website" do
    do_render
    response.should have_tag("a[href=?]", @congress_person.website_url)
  end

  describe "twitter widget" do
    describe "when congress person twitters" do
      before do
        @congress_person.stubs(:twitters?).returns(true)
        @congress_person.stubs(:tweets).returns(@tweets)
        @congress_person.stubs(:twitter_id).returns("congress_person")
      end
      it "should link to the congress person's twitter page" do
        template.stubs(:can_invite_to_twitter?).returns(true)
        do_render
        response.should have_tag("a[href=?]", "http://twitter.com/#{@congress_person.twitter_id}", "See Twitter Page")
      end
      it "links the recent tweets header to twitter" do
        do_render
        response.should have_tag("a[href=?]", "http://twitter.com/#{@congress_person.twitter_id}", "Recent tweets")
      end
    end
    describe "when congress person doesn't twitter" do
      before do
        @congress_person.stubs(:twitters?).returns(false)
      end
      it "links to a facebox twitter invitation if not already invited" do
        @congress_person.stubs(:email_address).returns('an email address')
        template.stubs(:can_invite_to_twitter?).returns(true)
        do_render
        response.should have_tag("a[href=?][rel*=facebox]", twitter_invite_path(@congress_person.crp_id))
      end
      it "indicates the user has already invited the congress person to twitter" do
        template.stubs(:can_invite_to_twitter?).returns(false)
        do_render
        response.should have_tag(".invited_to_twitter")
      end
      it "doesn't link to twitter invite if the congress person has no email address" do
        @congress_person.stubs(:email_address).returns("")
        template.stubs(:can_invite_to_twitter?).returns(true)
        do_render
        response.should_not have_tag("a", "Invite them now!")
      end
    end
  end

  describe "bills widget" do
    before do
      @bill = Factory(:bill)
    end

    describe "introduced_bills" do
      before do
        @congress_person.stubs(:introduced_bills).returns([@bill])
        @congress_person.stubs(:has_introduced_bills?).returns(true)
      end
      it "should list the congress person's introduced bills" do
        do_render
        response.should have_tag(".introduced_bills")
      end
      it "should link to a bill if it is linkable" do
        @bill.stubs(:link).returns('http://thomas.loc.gov/')
        do_render
        response.should have_tag("a[href=?]", 'http://thomas.loc.gov/')
      end
      it "should not link to a bill if it doesn't have a link" do
        @bill.stubs(:link).returns(nil)
        do_render
        response.should_not have_tag("a", @bill.title)
      end
    end

    describe "sponsored_bills" do
      before do
        @congress_person.stubs(:sponsored_bills).returns([@bill])
        @congress_person.stubs(:has_sponsored_bills?).returns(true)
      end
      it "should list the congress person's sponsored bills" do
        do_render
        response.should have_tag(".sponsored_bills")
      end
      it "should link to a bill if it is linkable" do
        @bill.stubs(:link).returns('http://thomas.loc.gov/')
        do_render
        response.should have_tag("a[href=?]", 'http://thomas.loc.gov/')
      end
      it "should not link to a bill if it doesn't have a link" do
        @bill.stubs(:link).returns(nil)
        do_render
        response.should_not have_tag("a", @bill.title)
      end
    end
  end

  it "includes the congress person's bio" do
    bio = Factory(:bio)
    @congress_person.stubs(:bio_text).returns(bio.bio)
    do_render
    response.should have_tag(".bio_text", bio.bio)
  end
  it "includes the congress person's committee memberships" do
    @congress_person.stubs(:committees).returns([Factory(:committee)])
    do_render
    response.should have_tag(".committees", @congress_person.committees.first.name)
  end
  it "includes the congress person's recent tweets if s/he twitters" do
    @congress_person.stubs(:twitters?).returns(true)
    @congress_person.stubs(:tweets).returns(@tweets)
    do_render
    response.should have_tag(".tweets ul li", :text => %r(#{@tweets.first.text}))
  end
  it "doesn't include the congress person's tweets otherwise" do
    @congress_person.stubs(:twitters?).returns(false)
    do_render
    response.should_not have_tag(".tweets")
  end
  it "has youtube embedded when the congress person can has youtubes" do
    Youtube.stubs(:most_recent).returns('a url')
    @congress_person.stubs(:can_has_youtubes?).returns(true)
    template.expects(:youtube_embed).returns('some html')
    do_render
  end

  describe "search bar" do
    it "links back to a locality with a valid zip" do
      template.stubs(:current_location).returns("53716")
      do_render
      response.should have_tag("a[href=?]", "/53716", "Back to Your District")
    end
    it "doesn't link back if there's no zip code" do
      do_render
      response.should_not have_tag("a", "Back to Your District")
    end
  end

  describe "commonly used words" do
    it "asks for the representatives most commonly used words" do
      do_render
      response.body.should include(@congress_person.latest_words.join(","))
    end
    it "links to the capitol words site" do
      do_render
      response.should have_tag("a[href^=?]", "http://www.capitolwords.org", "More information")
    end
  end
end
