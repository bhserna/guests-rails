class ApplicationMailer < ActionMailer::Base
  default from: 'notificationes@invita.app'
  layout 'mailer'

  def password_recovery_instructions(user_id)
    @user = Users.get_user(user_id, UserRecord)
    @token = Users.get_password_recovery_token(user_id, UserRecord)
    mail to: @user.email, subject: "Invita.app -> Instrucciones para recuperar contraseña"
  end

  def access_given_notification(person_id)
    @person = ListPeopleRecord.find(person_id)
    mail to: @person.email, subject: "Invita.app -> Acceso a lista de invitados"
  end
end
