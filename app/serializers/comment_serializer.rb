class CommentSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :chat_room_id, :article_id, :created_at, :updated_at
end