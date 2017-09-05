class ListNamesController < ApplicationController
  before_action :authenticate_user

  def edit
    form = Lists.edit_list_name_form(list_id, ListRecord)
    render locals: {form: form, list_id: list_id}
  end

  def update
    status = Lists.update_list_name(list_id, params[:list], ListRecord)

    if status.success?
      redirect_to list_path(list_id, group: params[:group])
    else
      render :edit, locals: {form: form, list_id: list_id}
    end
  end

  private

  def list_id
    params[:list_id]
  end
end
