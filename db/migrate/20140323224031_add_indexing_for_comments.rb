class AddIndexingForComments < ActiveRecord::Migration
  def self.up
    add_index :comments, :user_id
    add_index :comments, :chat_room_id
    add_index :comments, :article_id
  end

  def self.down
    remove_index :comments, :user_id
    remove_index :comments, :chat_room_id
    remove_index :comments, :article_id
  end
end
