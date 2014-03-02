namespace :import do
  desc "Pull set data from deckbrew"
  task :sets => :environment do
    ImportHelper::import_sets
  end
end