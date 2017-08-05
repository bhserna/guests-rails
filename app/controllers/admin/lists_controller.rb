class Admin::ListsController < ApplicationController
  before_action :authenticate_admin

  def index
    lists = Lists.get_all_lists(ListRecord, ListInvitationRecord, UserRecord)
    render locals: {lists: lists}
  end
end
