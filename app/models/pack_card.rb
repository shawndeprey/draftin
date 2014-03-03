# encoding: utf-8
class PackCard < ActiveRecord::Base
  # attributes: pack_id, card_id, created_at, updated_at
  belongs_to :pack
  belongs_to :card
end