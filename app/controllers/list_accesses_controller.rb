class ListAccessesController < ApplicationController
  before_action :authenticate_user
  before_action :authorize

  def index
    render locals: { list: list, people_with_access: people_with_access }
  end

  def new
    form = Lists.give_access_form
    render locals: { list: list, form: form }
  end

  def create
    status = Lists.give_access_to_person(list_id, params[:access], ListPeopleRecord)

    if status.success?
      redirect_to list_accesses_path(list_id)
    else
      render :new, locals: { list: list, form: status.form }
    end
  end

  def edit
    form = Lists.edit_access_form(person_id, ListPeopleRecord)
    render locals: { list: list, form: form, person_id: person_id }
  end

  def update
    status = Lists.update_access_for_person(person_id, params[:access], ListPeopleRecord)

    if status.success?
      redirect_to list_accesses_path(list_id)
    else
      render :edit, locals: { list: list, form: status.form, person_id: person_id }
    end
  end

  def destroy
    Lists.remove_access_for_person(person_id, ListPeopleRecord)
    redirect_to list_accesses_path(list_id)
  end

  private

  def authorize
    unless list.owner?(current_user)
      redirect_to list_path(list_id)
    end
  end

  def people_with_access
    Lists
    .current_access_details(list_id, ListRecord, ListPeopleRecord)
    .people_with_access
  end

  def list
    @list ||= Lists.get_list(list_id, ListRecord)
  end

  def person_id
    params[:id]
  end

  def list_id
    params[:list_id]
  end
end
