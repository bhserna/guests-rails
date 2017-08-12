class PasswordRecoveriesController < ApplicationController
  def new
  end

  def create
    status = Users.send_password_recovery_instructions(
      params[:password_recovery],
      Mailer,
      TokenGenerator,
      UserRecord
    )

    if status.success?
      redirect_to new_session_path,
        notice: "Se han enviado las instrucciones para recuperar tu contraseña"
    else
      render :new, locals: {error: status.error}
    end
  end

  class Mailer
    def self.send_password_recovery_instructions(user_id)
      ApplicationMailer.password_recovery_instructions(user_id).deliver
    end
  end

  class TokenGenerator
    def self.call(user_id, column)
      token = SecureRandom.uuid

      if UserRecord.find_by(column => token)
        call(user_id, column)
      else
        token
      end
    end
  end
end
