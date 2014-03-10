class PackSerializer < ActiveModel::Serializer
  attributes :id
  has_many :cards, serializer: CardSerializer
end