# encoding: utf-8
class User < ActiveRecord::Base
  nilify_blanks
  # attributes: last_seen, verified, email, receive_emails, recovery_hash, username, password, position, admin, created_at, updated_at
  has_many :draft_users
  has_many :drafts, :through => :draft_users
  has_many :user_cards
  has_many :cards, :through => :user_cards
  has_many :packs

  before_save :encrypt_password

  validates :email, presence: true
  validates :username, presence: true
  validates :password, presence: true

  def encrypt_password
    unless self.password.blank?
      unless self.password.length == 32
        self.password = ApplicationHelper::md5(self.password)
      end
    end
  end

  def generate_recovery_hash!
    self.recovery_hash = ApplicationHelper::md5("#{self.email}#{Random.rand(100000)}")
    self.save
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
      return pack.destroy if pack.cards.blank?
      other_user.add_pack!(pack)
    end
  end

  def current_pack
    self.packs.order('updated_at ASC').first
  end

  def select_multiverseid_from_current_pack!(multiverseid)
    card = Card.find_by_multiverseid(multiverseid)
    pack = self.current_pack
    return unless card && pack
    ActiveRecord::Base.transaction do
      pack.remove_card!(card)
      self.add_card!(card)
    end
    return card
  end

  def cards_by_name
    cards = {}
    self.cards.each do |card|
      cards[card.name] = 0 unless cards[card.name]
      cards[card.name] += 1
    end
    return cards
  end

  def see
    if self.last_seen.blank? || Time.now - self.last_seen > Time.now - 10.seconds.ago
      self.touch(:last_seen)
    end
  end

  def self.online_users
    User.where(:last_seen => (Time.now - 2.minutes)..Time.now).order("last_seen DESC")
  end
end