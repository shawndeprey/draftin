class Api::V1::DraftsController < Api::V1::BaseController
  before_filter :load_draft
  before_filter :load_set, :only => [:add_set, :remove_set]

  # GET /api/v1/drafts/:id.json
  def show
    render json: @draft, root: :draft, serializer: DraftSerializer
  end

  # PUT /api/v1/update/:draft_id.json
  def update
    return not_found unless @draft.user.id == @session_user.id
    if @draft.update_attributes(draft_params)
      MetricsHelper::track(MetricsHelper::UPDATE_DRAFT, {}, @session_user)
      render nothing: true, status: :accepted
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  # GET /drafts/:id/users/:user_id/kick
  def kick_user
    return not_found unless @draft.user.id == @session_user.id
    @kicked_user = User.find_by_id(params[:user_id])
    if @kicked_user
      MetricsHelper::track(MetricsHelper::KICK_USER, {
        kicked_user_id: @kicked_user.id,
        kicked_username: @kicked_user.username
      }, @session_user)
      @draft.remove_user!(@kicked_user)
    end
    render json:{}, status: 200
  end

  # POST /drafts/:id/card_sets.json?set_id=123
  def add_set
    @draft.add_set!(@set) if @draft.stage == CREATE_STAGE
    render nothing: true
  end

  # DELETE /drafts/:id/card_sets.json?set_id=123
  def remove_set
    @draft.remove_set!(@set) if @draft.stage == CREATE_STAGE
    render nothing: true
  end

  # GET /drafts/:id/start.json
  def start
    @draft.start_draft!
    MetricsHelper::track(MetricsHelper::START_DRAFT, {sets:@draft.card_sets.length,users:@draft.users.length}, @session_user)
    render nothing: true
  end

  # GET /drafts/:id/status.json
  def status
    render json: @draft, session_user: @session_user, root: :draft, serializer: DraftStatusSerializer
  end

  # GET /drafts/:id/select_card.json?multiverse_id=12345
  def select_card
    return not_found if params[:multiverse_id].blank? || params[:multiverse_id] == 'undefined'
    @card = @session_user.select_multiverseid_from_current_pack!(params[:multiverse_id])
    next_user = @draft.next_user(@session_user)
    @session_user.give_current_pack_to_user!(next_user)
    if @card
      MetricsHelper::track(MetricsHelper::SELECT_CARD, {
        multiverse_id: @card.multiverseid,
        name: @card.name,
        converted_mana_cost: @card.cmc,
        colors: @card.colors,
        card_type: @card.card_type,
        set: @card.card_set.short_name
      }, @session_user)
    end
    render json: {success:true}
  end

  # GET /drafts/:id/next_pack.json
  def next_pack
    @draft.next_pack!
    MetricsHelper::track(MetricsHelper::NEXT_PACK, {}, @session_user)
    render json: {success:true}
  end

  # GET /drafts/:id/end_draft.json
  def end_draft
    @draft.end_draft! if @draft.stage != END_STAGE
    MetricsHelper::track(MetricsHelper::END_DRAFT, {}, @session_user)
    render json: {success:true}
  end

  protected
  def load_draft
    @draft = Draft.find_by_id(params[:id]) || not_found
    @draft.see
  end

  def load_set
    @set = CardSet.find_by_id(params[:set_id]) || not_found
  end

  private
  def draft_params
    params.require(:draft).permit(:name, :password, :max_users)
  end
end
