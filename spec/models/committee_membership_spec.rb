require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CommitteeMembership do
  describe 'validation' do
    it 'requires a committee_id' do
      CommitteeMembership.new.should have(1).error_on(:committee_id)
    end
    it 'requires a govtrack_id' do
      CommitteeMembership.new.should have(1).error_on(:govtrack_id)
    end
    it "validates the uniqueness of committee_id within govtrack_id" do
      CommitteeMembership.create!(:committee_id => 1, :govtrack_id => '2')
      CommitteeMembership.new(:committee_id => 1, :govtrack_id => '2').should have(1).error_on(:committee_id)
    end
  end

  it "knows its committee" do
    CommitteeMembership.new.should respond_to(:committee)
  end
end
