class Pack < ActiveRecord::Base
  # attributes: set_id, user_id, order_received, created_at, updated_at
  belongs_to :set
  belongs_to :user
  has_many :pack_cards
  has_many :cards, :through => :pack_cards
end