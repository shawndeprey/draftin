class AddInitialIndexing < ActiveRecord::Migration
  def self.up
    add_index :users, :username, :unique => true

    add_index :cards, :name
    add_index :cards, :multiverseid, :unique => true

    add_index :drafts, :name

    add_index :sets, :short_name, :unique => true
    add_index :sets, :name, :unique => true

    add_index :draft_sets, :draft_id
    add_index :draft_sets, :set_id

    add_index :draft_users, :draft_id
    add_index :draft_users, :user_id
    add_index :draft_users, [:draft_id, :user_id], :unique => true

    add_index :user_cards, :user_id
    add_index :user_cards, :card_id

    add_index :user_packs, :user_id
    add_index :user_packs, :pack_id
    
    add_index :pack_cards, :pack_id
    add_index :pack_cards, :card_id
  end

  def self.down
    remove_index :users, :username

    remove_index :cards, :name
    remove_index :cards, :multiverseid

    remove_index :drafts, :name

    remove_index :sets, :short_name
    remove_index :sets, :name

    remove_index :draft_sets, :draft_id
    remove_index :draft_sets, :set_id

    remove_index :draft_users, :draft_id
    remove_index :draft_users, :user_id
    remove_index :draft_users, [:draft_id, :user_id]

    remove_index :user_cards, :user_id
    remove_index :user_cards, :card_id

    remove_index :user_packs, :user_id
    remove_index :user_packs, :pack_id
    
    remove_index :pack_cards, :pack_id
    remove_index :pack_cards, :card_id
  end
end