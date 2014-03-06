# encoding: utf-8
class User < ActiveRecord::Base
  nilify_blanks
  # attributes: username, password, position, created_at, updated_at
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

  def add_card!(card)
    self.cards << card unless card.blank?
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
      self.save
      other_user.add_pack!(pack)
    end
  end

  def current_pack
    Pack.where('user_id = :user_id AND order_received = 0', :user_id => self.id).first
  end
end