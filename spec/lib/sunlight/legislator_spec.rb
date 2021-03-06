require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Sunlight::Legislator do
  before do
    Sunlight.stubs(:api_key).returns('api key')
  end
  it "returns a single legislator" do
    stub_out_legislator_get_json_data
    Sunlight::Legislator.where("something" => "specified").should be_a_kind_of(Sunlight::Legislator)
  end

  it "returns nil if no legislator found" do
    Sunlight::Legislator.stubs(:get_cached_json_data).returns(nil)
    Sunlight::Legislator.where("something" => "specified").should be_nil
  end
end
