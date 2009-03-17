
namespace :govtrack do
  desc "Import bills from govtrack's XML file"
  task :import_bills => :environment do
    congressional_session = ENV['CSESSION'] || '110'
    Data::Govtrack.import_bills(congressional_session)
  end
end
