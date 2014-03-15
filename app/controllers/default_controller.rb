class DefaultController < ApplicationController
  skip_before_filter :require_session
  # GET /
  def index
    if @session_user
      @drafts = Draft.joins(:users).where('"users"."id" = :user_id', :user_id => @session_user.id)
                                    .order('updated_at desc')
                                    .paginate(:page => params[:page] || 1, :per_page => 5)
      MetricsHelper::track(MetricsHelper::VIEW_INDEX, {user_id:@session_user.id}, @session_user)
    end
  end

  # GET /example
  def example
  end

end