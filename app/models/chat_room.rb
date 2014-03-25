# encoding: utf-8
class ChatRoom < ActiveRecord::Base
  # attributes: title, created_at, updated_at
  has_many :comments

  def recent_comments
    Comment.where('"comments"."chat_room_id" = '+"#{self.id}")
           .order('"comments"."created_at" DESC')
           .paginate(page: 1, per_page: 50)
  end
end