# encoding: utf-8
class Draft < ActiveRecord::Base
  nilify_blanks
  # attributes: user_id, password, name, user_count, max_users, stage, created_at, updated_at
  belongs_to :user
  has_one :chat_room
  has_many :draft_users
  has_many :users, :through => :draft_users
  has_many :draft_card_sets
  has_many :card_sets, :through => :draft_card_sets

  validates :name, presence: true

  before_save :denormalize_user_count
  before_create :create_chat_room
  after_destroy :clean_dependents

  def clean_dependents
    self.draft_users.each{ |draft_user| draft_user.destroy }
    self.draft_card_sets.each{ |draft_card_set| draft_card_set.destroy }
    self.chat_room.destroy
  end

  def denormalize_user_count
    self.user_count = self.users.length
  end

  def create_chat_room
    self.chat_room = ChatRoom.new({title: self.name})
  end

  def open_user_slot?
    return (self.user_count < self.max_users)
  end

  def status
    return "In Lobby" if self.stage == CREATE_STAGE
    return "In Progress" if self.stage == DRAFT_STAGE
    return "Ended"
  end

  def set_draft_organizer!(user)
    self.user = user
    self.save
  end

  def add_user!(user)
    self.users << user
    self.save
  end

  def remove_user!(user)
    self.users.delete(user)
    return self.destroy if user == self.user # If the organizer leaves a draft, delete the draft
    self.save
  end

  def next_user(user)
    return self.users.where(position: 0).first if user.position == self.users.length - 1
    return self.users.where(position: user.position + 1).first
  end

  def add_set!(set)
    self.card_sets << set
    self.save
  end

  def remove_set!(set)
    card_set = DraftCardSet.where('draft_id = :draft_id AND card_set_id = :set_id', :draft_id => self.id, :set_id => set.id).limit(1)
    card_set.first.destroy unless card_set.blank?
  end

  def start_draft!
    ActiveRecord::Base.transaction do
      set = self.card_sets.first
      return unless set
      self.users.each_with_index do |user,position|
        user.prepare_for_draft!(position)
        user.add_pack!(set.generate_pack!)
      end
      self.remove_set!(set)
      self.stage = DRAFT_STAGE
      self.save
    end
  end

  def end_draft!
    self.stage = END_STAGE
    self.save
  end

  def next_pack!
    ActiveRecord::Base.transaction do
      set = self.card_sets.first
      return unless set
      self.users.each do |user|
        user.add_pack!(set.generate_pack!)
      end
      self.remove_set!(set)
      self.save
    end
  end
end