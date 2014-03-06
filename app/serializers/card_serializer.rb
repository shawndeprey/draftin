class CardSerializer < ActiveModel::Serializer
  attributes :id, :multiverseid, :name, :image_url
end