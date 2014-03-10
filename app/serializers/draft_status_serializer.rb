class DraftStatusSerializer < ActiveModel::Serializer
  attributes :id, :stage
  has_many :card_sets, serializer: CardSetLimitedSerializer
  has_many :users, serializer: UserLimitedSerializer
  has_one :current_pack, serializer: PackSerializer

  def current_pack
    @options[:session_user].current_pack
  end
end