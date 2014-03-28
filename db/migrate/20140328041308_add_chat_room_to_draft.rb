class AddChatRoomToDraft < ActiveRecord::Migration
  def change
    add_column :chat_rooms, :draft_id, :integer
  end
end
