class DefaultController < ApplicationController
  skip_before_filter :require_session, only: [:index]
  before_action :permissions_check, except: [:index]
  
  # GET /
  def index
    if @session_user
      @drafts = Draft.joins(:users).where('"users"."id" = :user_id', :user_id => @session_user.id)
                                    .order('updated_at desc')
                                    .paginate(:page => params[:page] || 1, :per_page => 5)
      MetricsHelper::track(MetricsHelper::VIEW_INDEX, {}, @session_user)
    end
  end

  # GET /example
  def example
  end

  # GET /admin
  def admin
  end

end