class SessionController < ApplicationController
  skip_before_filter :require_session, :only => [:create]
  # POST /session
  def create
    @user = User.find_by_username(params[:username])
    if @user && @user.password == ApplicationHelper::md5(params[:password])
      login @user
      redirect_to root_path, notice: "You have successfully logged as #{@user.username}."
    else
      redirect_to root_path, alert: "Username or password incorrect."
    end
  end

  # DELETE /session
  def destroy
    logout
    redirect_to root_path, notice: "You have successfully logged out."
  end

end