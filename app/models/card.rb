class Card < ActiveRecord::Base
  # attributes: set_id, layout, name, mana_cost, cmc, colors, type, supertypes, types, subtypes, 
  # rarity, text, flavor, artist, number, power, toughness, loyalty, multiverseid, 
  # variations, image_url, watermark, border, hand, life, created_at, updated_at
  belongs_to :set
end