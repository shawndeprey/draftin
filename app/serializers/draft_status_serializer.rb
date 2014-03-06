class DraftStatusSerializer < ActiveModel::Serializer
  attributes :id, :stage
  has_many :card_sets, serializer: CardSetLimitedSerializer
  has_many :users, serializer: UserLimitedSerializer
  has_one :current_pack, serializer: PackSerializer
  has_many :session_user_cards, serializer: CardSerializer

  def current_pack
    @options[:session_user].current_pack
  end

  def session_user_cards
    @options[:session_user].cards
  end
end