class AddMaxUsersToDrafts < ActiveRecord::Migration
  def change
    add_column :drafts, :max_users, :integer, default: 8
  end
end
