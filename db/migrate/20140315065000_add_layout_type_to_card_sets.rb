class AddLayoutTypeToCardSets < ActiveRecord::Migration
  def change
    add_column :card_sets, :layout_type, :integer
  end
end
