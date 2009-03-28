require File.expand_path(File.join(File.dirname(__FILE__) + '/../spec_helper.rb'))


class TestClass
  include ValueParser
end
describe Object do
  subject { TestClass.new }
  describe "#date?" do
    it "returns true if a valid date is passed" do
      subject.date?('12/31/2009').should be_true
    end
    it "returns false otherwise" do
      subject.date?('02/29/2007').should be_false
    end
  end

  describe "#numeric?" do
    it "returns true if a valid number is passed" do
      subject.numeric?('53716').should be_true
    end
    it "returns false otherwise" do
      subject.numeric?('five').should be_false
    end
  end

  describe "#zip_code?" do
    it "returns true if passed a numeric string with five digits" do
      subject.zip_code?('53716').should be_true
    end
    it "returns true if passed a five-digit integer" do
      subject.zip_code?(53716).should be_true
    end
    it "returns false otherwise" do
      subject.zip_code?('Madison, WI').should be_false
    end
  end
end
