require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LocalitiesHelper do
  describe '#party for' do
    def h_party_for(rep)
      helper.party_for(rep)
    end

    it 'is a democrat' do
      representative = stub(:party => 'Democrat')
      h_party_for(representative).should have_tag('span.democrat')
    end

    it 'is a republican' do
      representative = stub(:party => 'Republican')
      h_party_for(representative).should have_tag('span.republican')
    end
  end
end

