require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Sunlight::Legislator do
  it "returns a single legislator" do
    stub_out_legislator_get_json_data
    Legislator.where("something" => "specified").should be_a_kind_of(Legislator)
  end

  it "returns nil if no legislator found" do
    Legislator.stubs(:get_json_data).returns(nil)
    Legislator.where("something" => "specified").should be_nil
  end
end
