class InvitationsController < ApplicationController
  def create
    status = Lists.add_invitation(list_id, params.require(:invitation), ListInvitationRecord)

    if status.success?
      redirect_to list_path(list_id)
    else
      render status: 422, locals: {
        list: Lists.get_list(list_id, ListRecord),
        invitations: Lists.get_invitations(list_id, ListInvitationRecord),
        invitation_form: status.form
      }
    end
  end

  private

  def list_id
    params[:list_id]
  end
end
