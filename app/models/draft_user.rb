# encoding: utf-8
class DraftUser < ActiveRecord::Base
  # attributes: draft_id, user_id, created_at, updated_at
  belongs_to :draft
  belongs_to :user
end