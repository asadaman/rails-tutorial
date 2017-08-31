class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end

  class << self
    def send_activation_email(user)
      account_activation(user).deliver_now
    end

    def send_password_reset_email(user)
      password_reset(user).deliver_now
    end
  end
end
