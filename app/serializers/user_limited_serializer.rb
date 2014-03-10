class UserLimitedSerializer < ActiveModel::Serializer
  attributes :id, :username, :pack_count
  def pack_count
    object.packs.length
  end
end