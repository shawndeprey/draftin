# encoding: utf-8
class ChatRoom < ActiveRecord::Base
  # attributes: title, created_at, updated_at
  has_many :comments
end