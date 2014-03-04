class Api::V1::DraftsController < Api::V1::BaseController
  before_filter :load_draft

  # GET /api/v1/drafts/:id.json
  def show
    render json: @draft, root: :draft, serializer: DraftSerializer
  end

  protected
  def load_draft
    @draft = Draft.find_by_id(params[:id]) || not_found
  end
end
