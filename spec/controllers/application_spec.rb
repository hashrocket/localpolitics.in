require File.dirname(__FILE__) + '/../spec_helper.rb'

describe ApplicationController do

  describe "set_title" do
    it "sets the title instance variable" do
      controller.instance_variable_get(:@title).should be_nil
      controller.set_title('string')
      controller.instance_variable_get(:@title).should == 'string'
    end
  end

  describe "#set_location" do
    it "sets a flash variable" do
      flash[:location].should be_nil
      controller.set_location('53716')
      flash[:location].should == '53716'
    end
  end
end
