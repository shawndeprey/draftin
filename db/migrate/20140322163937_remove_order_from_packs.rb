class RemoveOrderFromPacks < ActiveRecord::Migration
  def self.up
    remove_column :packs, :order_received
  end
  def self.down
    add_column :packs, :order_received, :integer
  end
end
