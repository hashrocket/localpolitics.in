require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LocalitiesHelper do
  include LocalitiesHelper

  describe '#party for' do
    it 'is a democrat' do
      representative = stub(:party => 'Democrat')
      party_for(representative).should have_tag('span.democrat')
    end

    it 'is a republican' do
      representative = stub(:party => 'Republican')
      party_for(representative).should have_tag('span.republican')
    end
  end

  describe "#district_id_for" do
    it 'returns the district id, state for a representative' do
      representative = stub(:senator? => false, :district => '2', :state => "WY")
      district_id_for(representative).should == "District ID: 2 in WY"
    end
    it 'returns the (junior|senior) seat, state for a senator' do
      representative = stub(:senator? => true, :district => 'Senior Seat', :state => "WY")
      district_id_for(representative).should == "Senior Seat in WY"
    end

  end

end

