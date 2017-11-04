class DeliveryMarksController < ApplicationController
  include ListRenderer

  def create
    Lists.mark_invitation_as_delivered(invitation_id, ListInvitationRecord)
    update_list(list_id)
  end

  def destroy
    Lists.mark_invitation_as_not_delivered(invitation_id, ListInvitationRecord)
    update_list(list_id)
  end

  private

  def list_id
    params[:list_id]
  end

  def invitation_id
    params[:invitation_id]
  end
end
