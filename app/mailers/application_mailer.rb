class ApplicationMailer < ActionMailer::Base
  default from: 'bhserna@gmail.com'
  layout 'mailer'

  def password_recovery_instructions(user_id)
    @user = Users.get_user(user_id, UserRecord)
    @token = Users.get_password_recovery_token(user_id, UserRecord)
    mail to: @user.email, subject: "Simple Guest List -> Instrucciones para recuperar contraseña"
  end
end
