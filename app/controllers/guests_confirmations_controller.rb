class GuestsConfirmationsController < ApplicationController
  def new
    form = Lists.confirm_invitation_guests_form(invitation_id, ListInvitationRecord)
    render locals: {form: form, list_id: list_id, invitation_id: invitation_id}
  end

  def create
    Lists.confirm_invitation_guests(invitation_id, count_param, ListInvitationRecord)
    redirect_to list_path(list_id)
  end

  private

  def count_param
    params.require(:confirmation).fetch(:confirmed_guests_count)
  end

  def list_id
    params[:list_id]
  end

  def invitation_id
    params[:invitation_id]
  end
end