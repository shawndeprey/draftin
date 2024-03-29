class DefaultController < ApplicationController
  skip_before_filter :require_session, only: [:index, :example, :about, :donate]
  before_action :permissions_check, except: [:index, :example, :about, :donate]
  before_filter :require_admin_session, :only => [:admin]
  
  # GET /
  def index
    @open = true if params[:open]

    if @session_user
      @drafts = Draft.joins(:users).where('"users"."id" = :user_id', :user_id => @session_user.id)
                                    .order('updated_at desc')
                                    .paginate(:page => params[:page] || 1, :per_page => 5)
      MetricsHelper::track(MetricsHelper::VIEW_INDEX, {}, @session_user)
      @chat_room = ChatRoom.find_by_id(GLOBAL_CHAT_ROOM_ID)
      @recent_comments = @chat_room.recent_comments.reverse
      @online_users = User.online_users
      @recent_drafts = Draft.recent_drafts
    else
      @articles = Article.latest_articles(1, 3)
    end
  end

  # GET /example
  def example
  end

  # GET /admin
  def admin
  end

  # GET /about
  def about
    if @session_user
      MetricsHelper::track(MetricsHelper::VIEW_ABOUT, {}, @session_user)
    end
  end

  # GET /donate
  def donate
    if @session_user
      MetricsHelper::track(MetricsHelper::VIEW_DONATE, {}, @session_user)
    end
  end

end