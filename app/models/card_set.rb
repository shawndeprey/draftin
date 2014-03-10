# encoding: utf-8
class CardSet < ActiveRecord::Base
  nilify_blanks
  # attributes: short_name, name, border, set_type, url, cards_url, created_at, updated_at
  has_many :cards

  def generate_pack_for_user!(user)
    pack = Pack.new({card_set_id: self.id})
    pack_layout = ["common", "common", "common", "common", "common", "common", "common", "common", "common", "common",
     "uncommon", "uncommon", "uncommon", self.get_rare_card]

    pack_layout.each do |rarity|
      # Grab the possible choices for spot in pack
      card_choices = Card.where('rarity = :rarity AND card_set_id = :card_set_id', rarity: rarity, card_set_id: self.id)
      next if card_choices.blank?

      # Grab a single random card from among the choices
      card_choice_index = Random.rand(card_choices.length - 1)
      pack.add_card(card_choices[card_choice_index])
    end

    user.add_pack!(pack)
    return pack
  end

  def get_rare_card
    ((Random.rand(7) == 0) ? "mythic" : "rare") # 1:8 chance is standard for mythic rares
  end
end