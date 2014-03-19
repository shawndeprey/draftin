class AddUserToDraft < ActiveRecord::Migration
  def change
    add_column :drafts, :user_id, :integer
    add_column :drafts, :password, :string
  end
end
