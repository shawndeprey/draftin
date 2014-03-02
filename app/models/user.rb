# encoding: utf-8
class User < ActiveRecord::Base
  nilify_blanks
  # attributes: username, password, position, created_at, updated_at
  has_many :draft_users
  has_many :drafts, :through => :draft_users
  has_many :user_cards
  has_many :cards, :through => :user_cards
  has_many :packs
end