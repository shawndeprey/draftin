class UsersController < ApplicationController
  skip_before_filter :require_session, :only => [:create]

  # GET /users/:id
  def show
  end

  # POST /users
  def create
    @user = User.find_by_username(params[:user][:username]) || User.new(user_params)
    return redirect_to root_path, alert: "Username '#{@user.username}' already exists." if @user.id
    if @user.save
      MetricsHelper::track(MetricsHelper::CREATE_USER, {}, @user)
      MetricsHelper::send_user_to_mixpanel(@user)
      login @user
      redirect_to root_path, notice: "User #{@user.username} successfully created and logged in."
    else
      redirect_to root_path, alert: @user.errors.full_messages.join(" ")
    end
  end

  # GET /users/:id/my_cards.cod
  def export_cards
    
  end

  private
  def user_params
    params.require(:user).permit(:username, :password)
  end
end
