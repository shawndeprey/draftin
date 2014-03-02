class CardSet < ActiveRecord::Base
  # attributes: short_name, name, border, set_type, url, cards_url, created_at, updated_at
  has_many :cards
end