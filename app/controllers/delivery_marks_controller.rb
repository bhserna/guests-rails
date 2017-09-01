class DeliveryMarksController < ApplicationController
  def create
    Lists.mark_invitation_as_delivered(invitation_id, ListInvitationRecord)
    redirect_to list_path(list_id, group: params[:group])
  end

  def destroy
    Lists.mark_invitation_as_not_delivered(invitation_id, ListInvitationRecord)
    redirect_to list_path(list_id, group: params[:group])
  end

  private

  def list_id
    params[:list_id]
  end

  def invitation_id
    params[:invitation_id]
  end
end
