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
end