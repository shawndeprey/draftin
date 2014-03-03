class UsersController < ApplicationController
  skip_before_filter :require_session, :only => [:create]

  # GET /users/:id
  def show
  end

  # POST /users
  def create
    puts user_params
    @user = User.new(user_params)
    if @user.save
      login @user
      redirect_to root_path, notice: "User #{@user.username} successfully created and logged in."
    else
      redirect_to root_path, alert: "Error creating user: #{@user.errors.full_messages.join(" ")}"
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :password)
  end
end
