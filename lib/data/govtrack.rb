class Data::Govtrack

  class << self
    def bills_location_for(congressional_session)
      RAILS_ROOT + "/public/govtrack/#{congressional_session}_bills/"
    end

    def import_bills(congressional_session)
      bills_location = bills_location_for(congressional_session)
      Dir.new(bills_location).each do |file|
        next unless file =~ /\.xml$/i
        import_bill(bills_location + file)
      end
    end

    def import_bill(path)
      xml = File.read(path)
      xml_document = Nokogiri::XML.parse(xml)

      title               = xml_document.at('titles/title[@type=short]')
      description         = xml_document.at('titles/title[@type=official]')
      summary             = xml_document.at('summary')
      cosponsor_elements  = xml_document.search('cosponsors/cosponsor')
      cosponsor_ids       = cosponsor_elements.map{|e| e.get_attribute('id')}
      sponsor             = xml_document.at('sponsor')

      return unless title && sponsor

      bill = Bill.find_by_title_and_sponsor_id(title.text, sponsor['id']) || Bill.new

      bill.title          = title.text
      bill.description    = description.text if description
      bill.summary        = summary.text if summary
      bill.sponsor_id     = sponsor['id']
      bill.cosponsor_ids  = cosponsor_ids
      bill.save
    end

    def import_committee_memberships
      xml = File.read(RAILS_ROOT + "/public/govtrack/people.xml")
      xml_document = Nokogiri::XML.parse(xml)

      xml_document.search("people/person").each do |person|
        govtrack_id = person['id']
        person.search("current-committee-assignment").each do |assignment|
          committee_name = assignment['committee']
          persist_committee_membership(committee_name, govtrack_id)
        end
      end

    end
    def persist_committee_membership(committee_name, govtrack_id)
      committee = Committee.find_or_create_by_name(committee_name)
      unless committee.committee_memberships.exists?(:govtrack_id => govtrack_id)
        committee.committee_memberships.create(:govtrack_id => govtrack_id)
      end
    end
  end
end
