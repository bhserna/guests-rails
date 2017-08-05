class Admin::UsersController < ApplicationController
  before_action :authenticate_admin

  def index
    users = Users.get_users_list(UserRecord, ListRecord)
    render locals: {users: users}
  end
end
