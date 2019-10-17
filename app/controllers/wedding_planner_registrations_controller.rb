class WeddingPlannerRegistrationsController < ApplicationController
  before_action :check_current_user

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

  private def check_current_user
    if current_user?
      redirect_to lists_path
    end
  end
end
