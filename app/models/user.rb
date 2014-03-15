# encoding: utf-8
class User < ActiveRecord::Base
  nilify_blanks
  # attributes: username, password, position, admin, created_at, updated_at
  has_many :draft_users
  has_many :drafts, :through => :draft_users
  has_many :user_cards
  has_many :cards, :through => :user_cards
  has_many :packs

  before_save :encrypt_password

  def encrypt_password
    unless self.password.blank?
      unless self.password.length == 32
        self.password = ApplicationHelper::md5(self.password)
      end
    end
  end

  def can_join_draft?
    active_drafts = Draft.joins(:users).where('"users"."id" = :id AND "drafts"."stage" = :stage', id: self.id, stage: DRAFT_STAGE)
    return active_drafts.blank?
  end

  def add_card!(card)
    self.cards << card unless card.blank?
    self.save
  end

  def remove_card!(card)
    self.cards.delete(card)
    self.save
  end

  def prepare_for_draft!(position)
    self.cards.clear
    self.packs.clear
    self.position = position
    self.save
  end

  def add_pack!(pack)
    ActiveRecord::Base.transaction do
      pack.order_received = self.packs.length
      self.packs << pack
      pack.save
      self.save
    end
  end

  def give_current_pack_to_user!(other_user)
    ActiveRecord::Base.transaction do
      pack = self.current_pack
      return if pack.blank?
      self.packs.delete(pack)
      self.reorder_packs!
      self.save
      return pack.destroy if pack.cards.blank?
      other_user.add_pack!(pack)
    end
  end

  def current_pack
    Pack.where('user_id = :user_id AND order_received = 0', :user_id => self.id).first
  end

  def select_multiverseid_from_current_pack!(multiverseid)
    ActiveRecord::Base.transaction do
      pack = self.current_pack
      card = Card.find_by_multiverseid(multiverseid)
      return unless card && pack
      pack.remove_card!(card)
      self.add_card!(card)
    end
  end

  def reorder_packs!
    self.packs.order('order_received asc').each_with_index do |pack, i|
      pack.order_received = i
      pack.save
    end
  end

  def cards_by_name
    cards = {}
    self.cards.each do |card|
      cards[card.name] = 0 unless cards[card.name]
      cards[card.name] += 1
    end
    return cards
  end
end