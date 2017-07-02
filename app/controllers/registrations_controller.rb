class RegistrationsController < ApplicationController
  def new
    form = Users.register_form
    render locals: { form: form }
  end

  def create
    status = Users.register_user(
      params[:user],
      store: UserRecord,
      encryptor: Encryptor,
      session_store: session_store
    )

    if status.success?
      redirect_to lists_path
    else
      render :new, locals: { form: status.form }
    end
  end
end
