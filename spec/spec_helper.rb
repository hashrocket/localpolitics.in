# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
require 'spec/rails'

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # You can also declare which fixtures to use (for example fixtures for test/fixtures):
  #
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  #
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  #
  # For more information take a look at Spec::Runner::Configuration and Spec::Runner
end

class FakeGeocoder
  def initialize(api_key)
  end

  Location = Struct.new :latitude, :longitude, :postal_code, :coordinates
  def locate(place)
    data = fake_data
    Location.new data[:latitude], data[:longitude],
                 data[:postal_code], [data[:latitude], data[:longitude]]
  end

  def fake_data
    { :latitude => "30.3177",
      :longitude => "-81.41416",
      :postal_code => "32250" }
  end
end

Locality.geocoder = FakeGeocoder.new "foo"
Subscription.geocoder = FakeGeocoder.new "baz"

def fake_legislator_response
  {"response"=>{"legislators"=>[{"legislator"=>{"eventful_id"=>"P0-001-000016104-5", "congresspedia_url"=>"http://www.opencongress.org/wiki/Bill_Nelson", "webform"=>"http://billnelson.senate.gov/contact/email.cfm", "title"=>"Sen", "nickname"=>"", "crp_id"=>"N00009926", "district"=>"Senior Seat", "senate_class"=>"I", "fec_id"=>"S8FL00166", "middlename"=>"", "in_office"=>1, "gender"=>"M", "lastname"=>"Nelson", "firstname"=>"Bill", "website"=>"http://billnelson.senate.gov/", "bioguide_id"=>"N000032", "twitter_id"=>"", "phone"=>"202-224-5274", "congress_office"=>"716 Hart Senate Office Building", "govtrack_id"=>"300078", "fax"=>"202-228-2183", "sunlight_old_id"=>"fakeopenID509", "youtube_url"=>"http://www.youtube.com/SenBillNelson", "official_rss"=>"", "name_suffix"=>"Sr.", "votesmart_id"=>"30880", "email"=>"", "party"=>"D", "state"=>"FL"}}]}}
end

def fake_legislator
  Legislator.new(fake_legislator_response["response"]["legislators"].first["legislator"])
end

def stub_out_open_secrets_new
  OpenSecrets::CandidateSummary.any_instance.stubs(:summary_result).returns(fake_candidate_summary_response)
end

def fake_candidate_summary_response
  {"response"=>{"summary"=>{"cand_name"=>"Crenshaw, Ander ", "chamber"=>"H", "spent"=>"611094", "total"=>"679103", "origin"=>"Center for Responsive Politics", "cycle"=>"2008", "last_updated"=>"12/31/2008", "cash_on_hand"=>"662399", "debt"=>"0", "cid"=>"N00012739", "source"=>"http://www.opensecrets.org/politicians/summary.php?cid=N00012739&amp;cycle=2008", "next_election"=>"2008", "first_elected"=>"2000", "party"=>"R", "state"=>"FL"}}}
end


