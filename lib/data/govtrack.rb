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
  end
end
