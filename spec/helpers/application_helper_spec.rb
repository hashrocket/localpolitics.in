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
  end

  describe "title_and_full_name_for" do
    it "should return the correct string" do
      representative = stub('representative', :title => 'Title', :full_name => 'First Last')
      title_and_full_name_for(representative).should == "Title First Last"
    end
  end
end
