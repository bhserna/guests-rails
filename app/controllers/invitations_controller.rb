class InvitationsController < ApplicationController
  def create
    status = Lists.add_invitation(list_id, params.require(:invitation), ListInvitationRecord)

    if status.success?
      redirect_to list_path(list_id, group: params[:group])
    else
      render status: 422, locals: {
        list: Lists.get_list(list_id, ListRecord),
        groups: Lists.get_list_groups(list_id, ListInvitationRecord),
        invitations: Lists.get_invitations(list_id, ListInvitationRecord, group: params[:group]),
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
    redirect_to list_path(list_id, group: params[:group])
  end

  private

  def invitation_id
    params[:id]
  end

  def list_id
    params[:list_id]
  end
end
