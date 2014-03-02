module ImportHelper
  def self.import_sets
    puts "\e[32mImporting sets from deckbrew...\e[0m"
    sets_json = HttpHelper::get_secure(SETS_SOURCE)
    sets = ActiveSupport::JSON.decode(sets_json)
    return unless sets.is_a?(Array)

    sets.each do |s|
      next unless s["id"]

      # Find or create set model in our system, setting values to what the source has
      set = CardSet.find_by_short_name(s["id"]) || CardSet.new
      set.short_name = s["id"]
      set.name = s["name"] if s["name"]
      set.border = s["border"] if s["name"]
      set.set_type = s["type"] if s["name"]
      set.url = s["url"] if s["name"]
      set.cards_url = s["cards_url"] if s["name"]
      set.save

      puts "\e[32mSet \e[33m'#{set.short_name}'\e[32m - \e[33m'#{set.name}'\e[32m imported successfully...\e[0m"
    end

    puts "\e[32m#{APP_NAME} has \e[33m#{CardSet.count}\e[32m sets and \e[33m#{sets.length}\e[32m sets were just imported from deckbrew...\e[0m"
  end
end