class SessionsController < ApplicationController
  before_action :check_current_user, only: [:new, :create]

  def new
    render locals: {form: login_form}
  end

  def create
    status = Users.login(
      params[:user],
      store: UserRecord,
      encryptor: Encryptor,
      session_store: session_store
    )

    if status.success?
      redirect_to lists_path
    else
      flash[:error] = status.error
      render :new, locals: {form: login_form, error: status.error}
    end
  end

  def destroy
    Users.sign_out(session_store: session_store)
    redirect_to root_path
  end

  private def login_form
    Users.login_form
  end

  private def check_current_user
    if current_user?
      redirect_to lists_path
    end
  end
end
