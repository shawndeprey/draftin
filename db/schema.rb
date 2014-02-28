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

ActiveRecord::Schema.define(version: 20140228220537) do

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
    t.string   "image_name"
    t.string   "watermark"
    t.string   "border"
    t.integer  "hand"
    t.integer  "life"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "draft_sets", force: true do |t|
    t.integer  "draft_id"
    t.integer  "set_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "draft_users", force: true do |t|
    t.integer  "draft_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "drafts", force: true do |t|
    t.string   "name"
    t.integer  "user_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pack_cards", force: true do |t|
    t.integer  "pack_id"
    t.integer  "card_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "user_cards", force: true do |t|
    t.integer  "user_id"
    t.integer  "card_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_packs", force: true do |t|
    t.integer  "user_id"
    t.integer  "pack_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "password"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
