class UserMailer < ActionMailer::Base
  default from: "Draftin' Admin <shawndeprey@gmail.com>"

  def password_reset(user)
    @user = user
    mail(:to => @user.email, :subject => "Password Reset Instructions")
  end

  def verify(user)
    @user = user
    mail(:to => @user.email, :subject => "Verify Draftin' Account")
  end
end