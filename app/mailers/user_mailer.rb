class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user)
    @user = user

    mail to: user.email, subject: "Account activation for TechScreen.net"
  end

  def notify_of_new_user(user)
    @user = user 
    mail to: "paraglidingjeff@gmail.com", subject: "A new user " + user.email + " signed up."
  end
  
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset for TechScreen.net"
  end
  
  def contact_admin(email, content) 
    @email = email
    @content = content
    mail to: 'paraglidingjeff@gmail.com', subject: email + " gave feedback"
  end
end
