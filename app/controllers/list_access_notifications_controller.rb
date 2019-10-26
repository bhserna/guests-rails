class ListAccessNotificationsController < ApplicationController
  def create
    Lists.send_access_given_notification(params[:access_id], Time.current, ListPeopleRecord)
    flash[:notice] = "El correo fue programado para envío"
    redirect_to list_accesses_path(params[:list_id])
  end
end
