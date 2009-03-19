require File.dirname(__FILE__) + '/../spec_helper.rb'

describe ApplicationController do

  describe "set_title" do
    it "sets the title instance variable" do
      controller.instance_variable_get(:@title).should be_nil
      controller.set_title('string')
      controller.instance_variable_get(:@title).should == 'string'
    end
  end
end
