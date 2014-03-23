class UsersController < ApplicationController
  skip_before_filter :require_session, :only => [:verify, :create, :reset_password_request, :reset_password]

  # GET /users/:id
  def show
  end

  # POST /users
  def create
    @user = User.find_by_username(params[:user][:username]) || User.find_by_email(params[:user][:email])
    return redirect_to root_path, alert: "User with email #{params[:user][:email]} or username #{params[:user][:username]} already exists." if @user
    @user = User.new(user_params)
    if @user.save
      @user.generate_recovery_hash!
      MetricsHelper::track(MetricsHelper::CREATE_USER, {}, @user)
      MetricsHelper::send_user_to_mixpanel(@user)
      UserMailer.verify(@user).deliver
      redirect_to root_path, notice: "User #{@user.username} successfully created. Please check your email to verify your account."
    else
      redirect_to root_path, alert: @user.errors.full_messages.join(" ")
    end
  end

  # PATCH/PUT /users/1
  def update
    params[:user].delete(:password) if params[:user][:password].blank?
    if @session_user.update(user_params)
      redirect_to user_url(@session_user), notice: "Your information was successfully updated."
    else
      redirect_to user_url(@session_user), alert: @session_user.errors.full_messages.join(" ")
    end
  end

  # GET /users/1/verify?recovery_hash=2h3b23h2b1bnc9u2ncsd
  def verify
    @user = User.find_by_recovery_hash(params[:recovery_hash])
    if @user
      @user.verified = true
      @user.save
      MetricsHelper::track(MetricsHelper::VERIFY_USER, {}, @user)
      login @user
      redirect_to root_path, notice: "Account verified. Start Draftin'!"
    else
      redirect_to root_path, alert: "Unable to find user to verify. Please try again."
    end
  end

  # GET /users/:id/my_cards.cod
  def export_cards
  end

  # GET /users/:id/my_cards_list.cod
  def export_cards_list
  end

  # GET /users/reset_password_request?email=some@email.com
  def reset_password_request
    @user = User.find_by_email(params[:email])
    if @user
      @user.generate_recovery_hash!
      UserMailer.password_reset(@user).deliver
      MetricsHelper::track(MetricsHelper::PASSWORD_RESET_REQUEST, {}, @user)
      redirect_to root_path, notice: "Recovery email sent to #{@user.email}."
    else
      redirect_to root_path, alert: "Unable to find user with email #{params[:email]}. Please check the email and try again."
    end
  end

  # GET /users/reset_password?recovery_hash=2h3b23h2b1bnc9u2ncsd
  def reset_password
    @user = User.find_by_recovery_hash(params[:recovery_hash])
    if @user
      login @user
      MetricsHelper::track(MetricsHelper::PASSWORD_RESET, {}, @user)
      redirect_to user_path(@user), notice: "Temporary login successful. Reset your password below."
    else
      redirect_to root_path, alert: "Unable to find user with recovery code. Please try again."
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :username, :password, :receive_emails)
  end
end
