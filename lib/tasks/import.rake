namespace :import do
  desc "Pull set data from deckbrew"
  task :sets => :environment do
    ImportHelper::import_sets
  end

  desc "Pull card data from deckbrew"
  task :cards => :environment do
    ImportHelper::queue_card_importers
  end
end