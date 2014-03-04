# encoding: utf-8
class DraftCardSet < ActiveRecord::Base
  # attributes: draft_id, card_set_id, created_at, updated_at
  belongs_to :draft
  belongs_to :card_set
end