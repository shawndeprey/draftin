# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140228234326) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cards", force: true do |t|
    t.string   "layout"
    t.string   "name"
    t.string   "mana_cost"
    t.integer  "cmc"
    t.string   "colors"
    t.string   "type"
    t.string   "supertypes"
    t.string   "types"
    t.string   "subtypes"
    t.string   "rarity"
    t.text     "text"
    t.text     "flavor"
    t.string   "artist"
    t.string   "number"
    t.integer  "power"
    t.integer  "toughness"
    t.integer  "loyalty"
    t.integer  "multiverseid"
    t.string   "variations"
    t.string   "image_url"
    t.string   "watermark"
    t.string   "border"
    t.integer  "hand"
    t.integer  "life"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cards", ["multiverseid"], name: "index_cards_on_multiverseid", unique: true, using: :btree
  add_index "cards", ["name"], name: "index_cards_on_name", using: :btree

  create_table "draft_sets", force: true do |t|
    t.integer  "draft_id"
    t.integer  "set_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "draft_sets", ["draft_id"], name: "index_draft_sets_on_draft_id", using: :btree
  add_index "draft_sets", ["set_id"], name: "index_draft_sets_on_set_id", using: :btree

  create_table "draft_users", force: true do |t|
    t.integer  "draft_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "draft_users", ["draft_id", "user_id"], name: "index_draft_users_on_draft_id_and_user_id", unique: true, using: :btree
  add_index "draft_users", ["draft_id"], name: "index_draft_users_on_draft_id", using: :btree
  add_index "draft_users", ["user_id"], name: "index_draft_users_on_user_id", using: :btree

  create_table "drafts", force: true do |t|
    t.string   "name"
    t.integer  "user_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "drafts", ["name"], name: "index_drafts_on_name", using: :btree

  create_table "pack_cards", force: true do |t|
    t.integer  "pack_id"
    t.integer  "card_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pack_cards", ["card_id"], name: "index_pack_cards_on_card_id", using: :btree
  add_index "pack_cards", ["pack_id"], name: "index_pack_cards_on_pack_id", using: :btree

  create_table "packs", force: true do |t|
    t.integer  "set_id"
    t.integer  "order_received"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sets", force: true do |t|
    t.string   "short_name"
    t.string   "name"
    t.string   "border"
    t.string   "type"
    t.string   "url"
    t.string   "cards_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sets", ["name"], name: "index_sets_on_name", unique: true, using: :btree
  add_index "sets", ["short_name"], name: "index_sets_on_short_name", unique: true, using: :btree

  create_table "user_cards", force: true do |t|
    t.integer  "user_id"
    t.integer  "card_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_cards", ["card_id"], name: "index_user_cards_on_card_id", using: :btree
  add_index "user_cards", ["user_id"], name: "index_user_cards_on_user_id", using: :btree

  create_table "user_packs", force: true do |t|
    t.integer  "user_id"
    t.integer  "pack_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_packs", ["pack_id"], name: "index_user_packs_on_pack_id", using: :btree
  add_index "user_packs", ["user_id"], name: "index_user_packs_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "password"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
