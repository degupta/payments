class SignUpMailer < ActionMailer::Base
  default from: 'mailer@wearableintelligence.com'

  def sign_up_email(user, password, reset_password = false)
    @user = user
    @password = password
    @reset_password = reset_password
    mail(subject: "Sign Up Email", to: @user.email)
  end
end