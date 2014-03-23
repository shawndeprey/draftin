class CreatChatRoom < ActiveRecord::Migration
  def change
    create_table :chat_rooms do |t|
      t.string :title
      t.timestamps
    end
    create_table :comments do |t|
      t.belongs_to :user
      t.belongs_to :chat_room
      t.belongs_to :article
      t.text :content
      t.timestamps
    end
  end
end
