# encoding: utf-8
class Draft < ActiveRecord::Base
  nilify_blanks
  # attributes: name, user_count, created_at, updated_at
  has_many :draft_users
  has_many :users, :through => :draft_users
  has_many :draft_card_sets
  has_many :card_sets, :through => :draft_card_sets
end