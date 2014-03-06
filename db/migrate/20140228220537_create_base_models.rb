class CreateBaseModels < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.integer :position
      # has_many_drafts
      # has_many_cards
      # has_many_packs
      t.timestamps
    end

    create_table :cards do |t|
      t.integer :card_set_id
      t.string :layout # "Normal"
      t.string :name # "Research // Development"
      t.string :mana_cost # "{G}{U}"
      t.integer :cmc # 2 Converted Mana Cost
      t.string :colors # "Blue, Red"
      t.string :card_type # "Legendary Creature - Angel"
      t.string :supertypes # "Legendary"
      t.string :card_types # "Creature"
      t.string :subtypes # "Angel"
      t.string :rarity # "Rare"
      t.text :text # "{T}: You gain 1 life."
      t.text :flavor # "I'd like to buy a bowel."
      t.string :artist # "Mark Poole"
      t.string :number # "148a"
      t.integer :power # 4
      t.integer :toughness # 5
      t.integer :loyalty # 4
      t.integer :multiverseid # 2479
      t.string :variations # "78968, 85106"
      t.string :image_url # "https://image.deckbrew.com/mtg/multiverseid/179597.jpg"
      t.string :watermark # "Selesnya"
      t.string :border # "black"
      t.integer :hand # -3 Maximum hand size modifier. Only exists for Vanguard cards.
      t.integer :life # -10 Starting life total modifier. Only exists for Vanguard cards.
      t.timestamps
    end

    create_table :drafts do |t|
      t.string :name
      t.integer :user_count
      t.integer :stage, :default => 0
      # has_many_users
      # has_many_card_sets
      t.timestamps
    end

    create_table :packs do |t|
      t.integer :card_set_id
      t.integer :user_id
      t.integer :order_received, :default => 0 # Order user received the pack in
      # has_one_card_set
      # has_and_belongs_to_many_cards
      t.timestamps
    end

    create_table :card_sets do |t|
      t.string :short_name # "ARB"
      t.string :name # "Alara Reborn"
      t.string :border # "black"
      t.string :set_type # "expansion"
      t.string :url # "https://api.deckbrew.com/mtg/sets/ARB"
      t.string :cards_url # "https://api.deckbrew.com/mtg/cards?set=ARB"
      t.timestamps
    end

    create_table :draft_card_sets do |t|
      t.integer :draft_id
      t.integer :card_set_id
      t.timestamps
    end

    create_table :draft_users do |t|
      t.integer :draft_id
      t.integer :user_id
      t.timestamps
    end

    create_table :user_cards do |t|
      t.integer :user_id
      t.integer :card_id
      t.timestamps
    end

    create_table :pack_cards do |t|
      t.integer :pack_id
      t.integer :card_id
      t.timestamps
    end
  end
end
