# encoding: utf-8
class CardSet < ActiveRecord::Base
  nilify_blanks
  # attributes: short_name, name, border, set_type, url, cards_url, created_at, updated_at
  # has_mythics, has_rares, has_foils, pack_size, card_count, layout_type
  has_many :cards
  before_save :denormalize_data

  def denormalize_data
    self.card_count = self.cards.length
  end

  def generate_pack_for_user!(user)
    pack = Pack.new({card_set_id: self.id})
    self.pack_layout.each do |rarity|
      # Grab the possible choices for spot in pack
      card_choices = CardSet.get_cards_from_set_by_rarity(self.id, rarity)
      next if card_choices.blank?

      # Grab a single random card from among the choices
      while true
        card_choice_index = Random.rand(card_choices.length - 1)
        next if pack.has_card?(card_choices[card_choice_index]) # Avoid Duplicates

        pack.add_card(card_choices[card_choice_index])
        break
      end
    end

    # Add foil with random chance
    foil_card = self.get_foil_card
    pack.add_card(foil_card) if foil_card

    user.add_pack!(pack)
    return pack
  end

  def get_foil_card
    return unless self.has_foils && (Random.rand(5) == 0) # 1:6 chance to get a foil
    rand = Random.rand(13)
    if rand < 10 # 10:14 chance foil is common (0-9)
      rarity = "common"
    elsif rand > 9 && rand < 13 # 3:14 chance foil is uncommon (10 - 12)
    rarity = "uncommon"
    else # 1:14 chance foil is rare or mythic (13)
      if self.layout_type == 0 || self.layout_type == 6 # Has Mythics
        rarity = self.get_rare_card # 1:8 chance your foil is mythic, 7:8 it's rare
      else
        rarity = "rare"
      end
    end
    card_choices = CardSet.get_cards_from_set_by_rarity(self.id, rarity)
    return if card_choices.blank?
    puts "Returning #{rarity} foil!!! #{card_choices.length}"
    return card_choices[Random.rand(card_choices.length - 1)]
  end

  def pack_layout
    return ([
      ["common","common","common","common","common","common","common","common","common","common","uncommon","uncommon","uncommon",self.get_rare_card],
      ["common","common","common","common","common","common","common","common","common","common","uncommon","uncommon","uncommon","uncommon"],
      ["common","common","common","common","common","common","common","common","common","common",self.get_rare_card,self.get_rare_card,self.get_rare_card,self.get_rare_card],
      ["common","common","common","common","common","common","common","common","common","common","uncommon","uncommon","uncommon","rare"],
      ["common","common","common","common","common","common","common","common","common","common","common","uncommon","uncommon","uncommon","rare"],
      ["common","common","common","common","common","common","common","common","uncommon","uncommon","uncommon","rare","special","special","special"],
      ["common","common","common","common","common","common","common","common","common","common","uncommon","uncommon","uncommon",self.get_rare_card]
    ])[self.layout_type]
  end

  def get_rare_card
    if PACK_LAYOUT_2.include?(self.short_name)
      return ((Random.rand(7) == 0) ? "rare" : "uncommon") # 1:8 chance to get a rare
    else
      return ((Random.rand(7) == 0) ? "mythic" : "rare") # 1:8 chance is standard for mythic rares
    end
  end

  def self.get_cards_from_set_by_rarity(id, rarity)
    Card.where('rarity = :rarity AND card_set_id = :card_set_id', rarity: rarity, card_set_id: id)
  end

  def self.should_ignore_set?(short_name)
    return IGNORED_SETS.include?(short_name)
  end

  def self.allowed_sets
    sets = [["Sets",""]]
    CardSet.all.each do |s| 
      sets.push [s.name, s.id] unless CardSet.should_ignore_set?(s.short_name)
    end
    return sets
  end
end