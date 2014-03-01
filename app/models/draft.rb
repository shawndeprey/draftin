class Draft < ActiveRecord::Base
  # attributes: name, user_count, created_at, updated_at
  has_many :draft_users
  has_many :users, :through => :draft_users
  has_many :draft_sets
  has_many :sets, :through => :draft_sets
end