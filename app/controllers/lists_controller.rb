class ListsController < ApplicationController
  include ListRenderer
  before_action :authenticate_user
  before_action :authorize, only: [:show, :edit, :update]

  def index
    lists = Lists.lists_of_user(current_user, ListRecord, ListPeopleRecord)
    render locals: {lists: lists}
  end

  def show
    render_list(list_id)
  end

  def new
    form = Lists.new_list_form
    render locals: {form: form}
  end

  def create
    id_generator = ListIdGenerator.new(ListRecord)
    status = Lists.create_list(current_user.id, params[:list], ListRecord, id_generator)

    if status.success?
      redirect_to lists_path
    else
      render :new, locals: {form: status.form}
    end
  end

  def edit
    form = Lists.edit_list_form(list_id, ListRecord)
    render locals: {form: form, list_id: list_id}
  end

  def update
    status = Lists.update_list(list_id, params[:list], ListRecord)

    if status.success?
      redirect_to list_path(list_id, group: params[:group])
    else
      render :edit, locals: {form: status.form, list_id: list_id}
    end
  end

  private

  def authorize
    unless Lists.has_access?(current_user, list_id, ListRecord, ListPeopleRecord)
      redirect_to lists_path
    end
  end

  def list_id
    params[:id]
  end
end
