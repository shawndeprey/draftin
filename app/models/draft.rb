# encoding: utf-8
class Draft < ActiveRecord::Base
  nilify_blanks
  # attributes: name, user_count, stage, created_at, updated_at
  has_many :draft_users
  has_many :users, :through => :draft_users
  has_many :draft_card_sets
  has_many :card_sets, :through => :draft_card_sets

  before_save :denormalize_user_count

  def denormalize_user_count
    self.user_count = self.users.length
  end

  def status
    return "In Lobby" if self.stage == CREATE_STAGE
    return "In Progress" if self.stage == DRAFT_STAGE
    return "Ended"
  end

  def add_user!(user)
    self.users << user
    self.save
  end

  def remove_user!(user)
    self.users.delete(user)
    self.save
  end

  def add_set!(set)
    self.card_sets << set
    self.save
  end

  def remove_set!(set)
    card_set = DraftCardSet.where('draft_id = :draft_id AND card_set_id = :set_id', :draft_id => self.id, :set_id => set.id).limit(1)
    card_set.first.destroy unless card_set.blank?
  end
end