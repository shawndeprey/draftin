class Api::V1::DraftsController < Api::V1::BaseController
  before_filter :load_draft
  before_filter :load_set, :only => [:add_set, :remove_set]

  # GET /api/v1/drafts/:id.json
  def show
    render json: @draft, root: :draft, serializer: DraftSerializer
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
    @session_user.select_multiverseid_from_current_pack!(params[:multiverse_id])
    next_user = @draft.next_user(@session_user)
    @session_user.give_current_pack_to_user!(next_user)
    MetricsHelper::track(MetricsHelper::SELECT_CARD, {multiverse_id:params[:multiverse_id]}, @session_user)
    render json: {success:true}
  end

  # GET /drafts/:id/next_pack.json
  def next_pack
    @draft.next_pack!
  end

  # GET /drafts/:id/end_draft.json
  def end_draft
    @draft.end_draft! if @draft.stage != END_STAGE
  end

  protected
  def load_draft
    @draft = Draft.find_by_id(params[:id]) || not_found
  end

  def load_set
    @set = CardSet.find_by_id(params[:set_id]) || not_found
  end
end
