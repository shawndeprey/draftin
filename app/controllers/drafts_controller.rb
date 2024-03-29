class DraftsController < ApplicationController
  before_filter :load_draft, :except => [:index, :create]
  before_filter :require_admin_session, :only => [:index]

  # GET /drafts
  def index
    @drafts = Draft.where('id >= 0').order('updated_at DESC').paginate(page: params[:page])
  end

  # GET /drafts/:id
  def show
    # Ensure user is in draft
    return redirect_to root_path, alert: "You are not in that draft. Please join it using the form below." unless @draft.users.include?(@session_user)
    @current_pack = @session_user.current_pack
    @chat_room = @draft.chat_room
    @recent_comments = @chat_room.recent_comments.reverse
    MetricsHelper::track(MetricsHelper::VIEW_DRAFT, {draft_id:@draft.id,name:@draft.name}, @session_user)
  end

  # POST /drafts
  def create
    @draft = Draft.new(draft_params)
    if @draft.save
      @draft.add_user!(@session_user)
      @draft.set_draft_organizer!(@session_user)
      MetricsHelper::track(MetricsHelper::CREATE_DRAFT, {}, @session_user)
      redirect_to @draft
    else
      redirect_to root_path, alert: "Error creating draft: #{@draft.errors.full_messages.join(" ")}"
    end
  end

  # PUT /update/:draft_id
  def update
    if @draft.user.id == @session_user.id
      if @draft.update_attributes(draft_params)
        MetricsHelper::track(MetricsHelper::UPDATE_DRAFT, {}, @session_user)
        redirect_to @draft
      else
        redirect_to root_path, alert: "Error updating draft."
      end
    else
      redirect_to root_path, alert: "Only the draft coordinator may do that."
    end
  end

  # DELETE /drafts/id
  def destroy
    @draft.destroy
    MetricsHelper::track(MetricsHelper::DESTROY_DRAFT, {}, @session_user)
    redirect_to root_path, notice: "Successfully annihilated draft!"
  end

  # POST /drafts/join
  def add_user
    if @draft.stage == CREATE_STAGE
      MetricsHelper::track(MetricsHelper::JOIN_DRAFT, {}, @session_user)
      # Ensure there is an open slot
      unless @draft.open_user_slot?
        return redirect_to root_path, alert: "Draft #{@draft.name} is full. Sorry about that!"
      end

      # Ensure passwords are correct
      if !@draft.password.blank? && @draft.password != params[:password] && @draft.user.id != @session_user.id
        return redirect_to root_path, alert: "This draft requires a password to join." if params[:password].blank?
        return redirect_to root_path, alert: "#{params[:password]} is not the password for #{@draft.name}"
      end

      @draft.add_user!(@session_user)
      redirect_to @draft, password: params[:password]
    else
      redirect_to root_path, alert: "Draft has already started. Sorry about that!"
    end
  end

  # DELETE /drafts/:id/leave
  def remove_user
    @draft.remove_user!(@session_user)
    MetricsHelper::track(MetricsHelper::LEAVE_DRAFT, {}, @session_user)
    redirect_to root_path, notice: "You left the draft."
  end

  protected
  def load_draft
    @draft = Draft.find_by_id(params[:id])
    return redirect_to root_path, alert: "Draft does not exist. Sorry about that!" unless @draft
    @draft.see
  end

  private
  def draft_params
    params.require(:draft).permit(:name, :password)
  end
end
