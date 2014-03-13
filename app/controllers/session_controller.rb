class SessionController < ApplicationController
  skip_before_filter :require_session, :only => [:create]
  # POST /session
  def create
    @user = User.find_by_username(params[:username])
    if @user && @user.password == ApplicationHelper::md5(params[:password])
      MetricsHelper::track(MetricsHelper::LOGIN, {}, @user)
      login @user
      redirect_to root_path
    else
      redirect_to root_path, alert: "Username or password incorrect."
    end
  end

  # DELETE /session
  def destroy
    MetricsHelper::track(MetricsHelper::LOGOUT, {}, @session_user)
    logout
    redirect_to root_path
  end

end