# encoding: utf-8
class UserCard < ActiveRecord::Base
  # attributes: user_id, card_id, created_at, updated_at
  belongs_to :user
  belongs_to :card
end