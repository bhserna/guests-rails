class PasswordRecoveriesController < ApplicationController
  def new
  end

  def create
    status = Users.send_password_recovery_instructions(params[:password_recovery])

    if status.success?
      redirect_to new_session_path
    else
      render :new, locals: {error: status.error}
    end
  end
end
