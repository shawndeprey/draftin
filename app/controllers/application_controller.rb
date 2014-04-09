class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :require_session
  before_filter :load_session_user

  include ApplicationHelper

  def require_session
    unless session[:user_id]
      redirect_to root_path, alert: "You must login to do that."
      return false
    end
  end

  def load_session_user
    if session[:user_id]
      @session_user = User.find_by_id(session[:user_id])
      @session_user.see if @session_user
    end
  end

  def require_admin_session
    unless @session_user && @session_user.admin?
      return redirect_to root_path, alert: "You must be an admin to do that."
    end
  end

  def login(user)
    session[:user_id] = user.id
  end

  def logout
    session[:user_id] = nil
  end

  def permissions_check
    return redirect_to root_path, alert: "Only admins can do that." unless @session_user.admin?
  end

  def render_not_found
    redirect_to root_path, alert: "We couldn't find the page you were looking for. Sorry about that!"
  end

  def not_found
    raise ActionController::RoutingError.new("We couldn't find the page you were looking for. Sorry about that!")
  end
end
