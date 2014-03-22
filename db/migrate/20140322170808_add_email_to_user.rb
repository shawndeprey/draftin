class AddEmailToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :email, :string
    add_column :users, :receive_emails, :boolean, :default => true
    add_column :users, :recovery_hash, :string
    add_column :users, :verified, :boolean, :default => false
    add_index :users, :email
    add_index :users, :receive_emails
    add_index :users, :recovery_hash
  end

  def self.down
    remove_index :users, :email
    remove_index :users, :receive_emails
    remove_index :users, :recovery_hash
    remove_column :users, :email
    remove_column :users, :receive_emails
    remove_column :users, :recovery_hash
    remove_column :users, :verified
  end
end
