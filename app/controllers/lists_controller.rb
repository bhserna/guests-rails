class ListsController < ApplicationController
  before_action :authenticate_user

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

  def index
    lists = Lists.lists_of_user(current_user, ListRecord, ListPeopleRecord)
    render locals: {lists: lists}
  end

  def show
    render locals: {
      list: Lists.get_list(list_id, ListRecord),
      groups: Lists.get_list_groups(list_id, ListInvitationRecord),
      invitations: Lists.get_invitations(list_id, ListInvitationRecord),
      invitation_form: Lists.get_invitation_form
    }
  end

  private

  def list_id
    params[:id]
  end
end
