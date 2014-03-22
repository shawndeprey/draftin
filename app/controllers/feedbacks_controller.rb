class FeedbacksController < ApplicationController
  before_action :permissions_check, except: [:create]
  before_action :set_feedback, only: [:destroy, :update]

  # GET /feedbacks
  def index
    @handled = params[:handled] == "1" ? "TRUE" : "FALSE"
    @feedbacks = Feedback.where('"feedbacks"."id" >= 0 AND "feedbacks"."handled" = ' + "#{@handled}")
                         .order('"feedbacks"."updated_at" ASC').paginate(page: params[:page], per_page: 10)
  end

  # POST /feedbacks
  def create
    @feedback = Feedback.new(feedback_params)
    @feedback.user = @session_user
    if @feedback.save
      MetricsHelper::track(MetricsHelper::SUBMIT_FEEDBACK, {}, @session_user)
      redirect_to root_path, notice: "Your feedback is greatly appreciated. Thank you!"
    else
      render action: "new"
    end
  end

  # PATCH/PUT /feedbacks/1
  def update
    @feedback.update(feedback_params)
    redirect_to feedbacks_url, notice: "Feedback was successfully updated."
  end

  # DELETE /feedbacks/1
  def destroy
    @feedback.destroy
    redirect_to feedbacks_url, notice: "Feedback was successfully destroyed."
  end

  private
  def set_feedback
    @feedback = Feedback.find(params[:id])
  end

  def feedback_params
    params.require(:feedback).permit(:title, :content, :handled)
  end
end