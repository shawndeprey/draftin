class Card < ActiveRecord::Base
  # attributes: card_set_id, layout, name, mana_cost, cmc, colors, card_type, supertypes, card_types, subtypes, 
  # rarity, text, flavor, artist, number, power, toughness, loyalty, multiverseid, 
  # variations, image_url, watermark, border, hand, life, created_at, updated_at
  belongs_to :card_set
end