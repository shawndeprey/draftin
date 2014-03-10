# encoding: utf-8
class Pack < ActiveRecord::Base
  nilify_blanks
  # attributes: card_set_id, user_id, order_received, created_at, updated_at
  belongs_to :card_set
  belongs_to :user
  has_many :pack_cards
  has_many :cards, :through => :pack_cards

  def add_card(card)
    self.cards << card unless card.blank?
  end

  def remove_card!(card)
    self.cards.delete(card)
    self.save
  end
end