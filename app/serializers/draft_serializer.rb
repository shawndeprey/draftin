class DraftSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_count, :stage, :created_at, :updated_at
  has_many :users, serializer: UserLimitedSerializer
  has_many :card_sets, serializer: CardSetLimitedSerializer
end