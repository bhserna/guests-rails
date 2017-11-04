class InvitationsController < ApplicationController
  include ListRenderer

  def new
    render locals: {
      list_id: list_id,
      groups: Lists.get_list_groups(list_id, ListInvitationRecord),
      invitation_form: Lists.get_invitation_form
    }
  end

  def create
    status = Lists.add_invitation(list_id, params.require(:invitation), ListInvitationRecord)

    if status.success?
      update_list(list_id, focus_invitation_title: true)
    else
      render status: 422, locals: {
        list_id: list_id,
        groups: Lists.get_list_groups(list_id, ListInvitationRecord),
        invitation_form: status.form
      }
    end
  end

  def edit
    form = Lists.get_edit_invitation_form(invitation_id, ListInvitationRecord)
    render locals: {
      form: form,
      list_id: list_id,
      invitation_id: invitation_id,
      groups: Lists.get_list_groups(list_id, ListInvitationRecord)
    }
  end

  def update
    status = Lists.update_invitation(invitation_id, params.require(:invitation), ListInvitationRecord)

    if status.success?
      redirect_to list_path(list_id, group: params[:group])
    else
      render :edit, locals: {
        form: status.form,
        list_id: list_id,
        invitation_id: invitation_id,
        groups: List.get_list_groups(list_id, ListInvitationRecord)
      }
    end
  end

  def destroy
    Lists.delete_invitation(invitation_id, ListInvitationRecord)
    update_list(list_id)
  end

  private

  def invitation_id
    params[:id]
  end

  def list_id
    params[:list_id]
  end
end
