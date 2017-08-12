class PasswordsController < ApplicationController
  def edit
    render locals: {
      token: token = params[:id],
      user: Users.find_by_password_recovery_token(token, UserRecord)
    }
  end

  def update
    token = params[:id]
    status =  Users.update_password(
      token, params[:user],
      store: UserRecord,
      encryptor: Encryptor,
      session_store: session_store
    )

    if status.success?
      redirect_to lists_path, notice: "Tu contraseña ha sido actualizada"
    else
      render :edit, locals: {
        token: token = params[:id],
        user: Users.find_by_password_recovery_token(token, UserRecord),
        error: status.error
      }
    end
  end
end
