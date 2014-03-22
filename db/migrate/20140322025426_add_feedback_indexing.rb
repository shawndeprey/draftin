class AddFeedbackIndexing < ActiveRecord::Migration
  def self.up
    add_index :feedbacks, :user_id
  end

  def self.down
    remove_index :feedbacks, :user_id
  end
end
