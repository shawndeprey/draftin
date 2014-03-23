# encoding: utf-8
class Comment < ActiveRecord::Base
  # attributes: content, user_id, chat_room_id, article_id, created_at, updated_at
  belongs_to :user
  belongs_to :chat_room
  belongs_to :article
  default_scope includes(:user)

  validates :content, presence: true
  validates :user_id, presence: true
end