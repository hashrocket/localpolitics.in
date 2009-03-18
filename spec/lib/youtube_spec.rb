require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Youtube do
  before do
    @congress_person = CongressPerson.new(fake_legislator)
  end
  describe "@youtube_uploads_url" do
    it "returns the correct url" do
      @congress_person.stubs(:youtube_url).returns("http://www.youtube.com/SenRussFeingold")
      Youtube.youtube_uploads_url_for(@congress_person).should == "http://gdata.youtube.com/feeds/api/users/SenRussFeingold/uploads"
    end
    it "returns nil otherwise" do
      @congress_person.stubs(:youtube_url).returns(nil)
      Youtube.youtube_uploads_url_for(@congress_person).should be_nil
    end
  end
  describe "most_recent" do
    it "should get the correct Youtube video" do
      Youtube.stubs(:youtube_uploads_url_for).returns(File.join(RAILS_ROOT + '/spec/fixtures/youtube_uploads.xml'))
      Youtube.most_recent(@congress_person).should == "http://www.youtube.com/v/gaI_6LByaIA&f=user_uploads&app=youtube_gdata"
    end
  end

end
