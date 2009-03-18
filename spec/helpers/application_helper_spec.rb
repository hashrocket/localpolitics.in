require File.dirname(__FILE__) + '/../spec_helper.rb'

describe ApplicationHelper do
  include ApplicationHelper

  describe "twitter_url_for" do
    it "should be the correct twitter url" do
      representative = stub('representative', :twitter_id => 'slug')
      twitter_url_for(representative).should == "http://twitter.com/slug"
    end
  end

  describe "twitter_link_for" do
    before do
      @representative = stub('representative', :twitter_id => 'slug')
    end
    it "should be a link" do
      twitter_link_for(@representative).should have_tag("a", "Follow On Twitter")
    end
    it "should call twitter_url_for" do
      expects(:twitter_url_for).returns('a url')
      twitter_link_for(@representative)
    end
    it "should return nil if the representative doesn't have a twitter id" do
      @representative.stubs(:twitter_id).returns('')
      twitter_link_for(@representative).should be_nil
    end
    it "should set the link text to another string" do
      twitter_link_for(@representative, "all").should have_tag("a", "all")
    end
  end

  describe "title_and_full_name_for" do
    it "should return the correct string" do
      representative = stub('representative', :title => 'Title', :full_name => 'First Last')
      title_and_full_name_for(representative).should == "Title First Last"
    end
  end

  describe "govtrack_photo" do
    before do
      @congress_person = stub('congress_person', :govtrack_id => '30001', :full_name => 'Russell "Cheesecurd" Feingold')
      File.stubs(:exists?).returns(true)
    end
    it "returns an image tag with the 200px-sized govtrack photo as src" do
      govtrack_photo(@congress_person).should have_tag("img[src=?]", "/govtrack/photos/#{@congress_person.govtrack_id}-200px.jpeg")
    end
    it "returns an image tag with the default photo when no photo exists" do
      File.stubs(:exists?).returns(false)
      govtrack_photo(@congress_person).should have_tag("img[src=?]", "/govtrack/photos/no_picture.jpeg")
    end
    it "allows different sizing" do
      govtrack_photo(@congress_person, :size => 50).should include("-50px")
    end
    it "has an alt attribute" do
      govtrack_photo(@congress_person).should have_tag("img[alt=?]", 'Photo of Russell &quot;Cheesecurd&quot; Feingold')
    end
  end

  describe "youtube_embed" do
    it "should return an embed tag" do
      youtube_embed("some url").should include("<embed src=\"some url\"")
    end
  end
end
