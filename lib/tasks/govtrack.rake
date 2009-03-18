namespace :govtrack do
  desc "Import bills from govtrack's XML file"
  task :import_bills => :environment do
    congressional_session = ENV['CSESSION'] || '110'
    Data::Govtrack.import_bills(congressional_session)
  end

  desc "Import bios from the bioguide site"
  task :import_bios => :environment do
    Data::Bioguide.scrape_bioguide_site
  end

  desc "Import committee memberships from Govtrack xml document"
  task :import_committees => :environment do
    Data::Govtrack.import_committee_memberships
  end
end
