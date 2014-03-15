module ImportHelper
  def self.import_sets
    puts "\e[32mImporting sets from deckbrew...\e[0m"
    sets_json = HttpHelper::get_secure(SETS_SOURCE)
    sets = ActiveSupport::JSON.decode(sets_json)
    return unless sets.is_a?(Array) || sets.blank?

    sets.each do |s|
      next unless s["id"]

      # Find or create set model in our system, setting values to what the source has
      set = CardSet.find_by_short_name(s["id"]) || CardSet.new
      set.short_name = s["id"]
      set.name = s["name"]
      set.border = s["border"]
      set.set_type = s["type"]
      set.url = s["url"]
      set.cards_url = s["cards_url"]
      set.layout_type = ImportHelper::get_set_layout_type(set.short_name)
      set.has_foils = SETS_WITH_FOILS.include?(set.short_name)
      set.save

      puts "\e[32mSet \e[33m'#{set.short_name}'\e[32m - \e[33m'#{set.name}'\e[32m imported successfully...\e[0m"
    end

    puts "\e[32m#{APP_NAME} has \e[33m#{CardSet.count}\e[32m sets and \e[33m#{sets.length}\e[32m sets were just imported from deckbrew...\e[0m"
  end

  def self.get_set_layout_type(short_name)
    if PACK_LAYOUT_1.include?(short_name)
      return 1
    elsif PACK_LAYOUT_2.include?(short_name)
      return 2
    elsif PACK_LAYOUT_3.include?(short_name)
      return 3
    elsif PACK_LAYOUT_4.include?(short_name)
      return 4
    elsif PACK_LAYOUT_5.include?(short_name)
      return 5
    elsif PACK_LAYOUT_6.include?(short_name)
      return 6
    else
      return 0
    end
  end

  def self.queue_card_importers
    Sidekiq::Client.push_bulk('class' => CardPageImportWorker, 'args' => (0..PAGES_OF_CARDS).map{|p|[p]})
    puts "\e[32mSuccessfully queued \e[33m#{PAGES_OF_CARDS}\e[32m pages of cards to be imported...\e[0m"
  end

  def self.import_page_of_cards(page)
    puts "\e[32mStarting import of page \e[33m#{page}\e[32m of cards from deckbrew...\e[0m"
    cards_json = HttpHelper::get_secure("#{CARDS_SOURCE}?page=#{page}")
    cards = ActiveSupport::JSON.decode(cards_json)
    return unless cards.is_a?(Array) || cards.blank?

    cards.each do |c|
      next unless c["name"] && c["editions"]

      c["editions"].each do |e|
        next unless e["multiverse_id"]

        set = CardSet.find_by_short_name(e["set_id"])
        next if set.blank?

        begin
          card = Card.find_by_multiverseid(e["multiverse_id"]) || Card.new
          card.card_set = set
          card.multiverseid = e["multiverse_id"]
          card.name = c["name"]
          card.layout = e["layout"]
          card.mana_cost = c["cost"]
          card.cmc = c["cmc"]
          card.colors = c["colors"].join(",") unless c["colors"].blank?
          card.card_type = ImportHelper::compile_full_card_type(c["supertypes"], c["types"], c["subtypes"])
          card.supertypes = c["supertypes"].join(",") unless c["supertypes"].blank?
          card.card_types = c["types"].join(",") unless c["types"].blank?
          card.subtypes = c["subtypes"].join(",") unless c["subtypes"].blank?
          card.rarity = e["rarity"]
          card.text = c["text"]
          card.flavor = e["flavor"]
          card.artist = e["artist"]
          card.number = e["number"]
          card.power = c["power"].to_i unless c["power"].blank?
          card.toughness = c["toughness"].to_i unless c["toughness"].blank?
          card.loyalty = c["loyalty"]
          card.image_url = e["image_url"]
          card.border = set.border
          card.hand = c["hand"] || e["hand"]
          card.life = c["life"] || e["life"]
          #card.variations = c["variations"] Don't need this yet
          #card.watermark = e["watermark"] Not in deckbrew source
          card.save
          puts "\e[32mSuccessfully imported multiverse_id \e[33m#{card.multiverseid}\e[32m - \e[33m#{card.name}\e[32m card from deckbrew...\e[0m"
        rescue StandardError => e
          puts "\e[31mError importing multiverse_id \e[33m#{card.multiverseid}\e[31m - page: \e[33m#{page}\e[31m card from deckbrew...\e[0m"
        end
      end
    end
    puts("\e[32mSuccessfully imported page \e[33m#{page}\e[32m of cards from deckbrew...\e[0m")
  end

  def self.compile_full_card_type(super_types, types, sub_types)
    type = super_types.blank? ? "" : super_types.map(&:capitalize).join(" ")
    type = types.blank? ? type : "#{type} #{types.map(&:capitalize).join(" ")}"
    type = sub_types.blank? ? type : "#{type} - #{sub_types.map(&:capitalize).join(" ")}"
    return type.blank? ? type : type.strip!
  end
end