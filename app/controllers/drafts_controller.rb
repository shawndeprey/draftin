class DraftsController < ApplicationController
  before_filter :load_draft, :except => [:create]

  # GET /drafts/:id
  def show
    @current_pack = @session_user.current_pack
  end

  # POST /drafts
  def create
    @draft = Draft.new(draft_params)
    if @draft.save
      @draft.add_user!(@session_user)
      redirect_to @draft
    else
      redirect_to root_path, alert: "Error creating draft. Please try again."
    end
  end

  # DELETE /drafts/id
  def destroy
    @draft.destroy
    redirect_to root_path, notice: "Successfully annihilated draft!"
  end

  # POST /drafts/join
  def add_user
    if @draft.stage == CREATE_STAGE
      @draft.add_user!(@session_user)
      redirect_to @draft
    else
      redirect_to root_path, alert: "Draft is no longer available for newbies."
    end
  end

  # DELETE /drafts/:id/leave
  def remove_user
    if @draft.stage == CREATE_STAGE
      @draft.remove_user!(@session_user)
      redirect_to root_path, notice: "Successfully quit draft."
    else
      redirect_to root_path, alert: "Draft has already started. Stop trolling people."
    end
  end

  protected
  def load_draft
    @draft = Draft.find_by_id(params[:id])
    return render_not_found unless @draft
  end

  private
  def draft_params
    params.require(:draft).permit(:name)
  end
end
