class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :current_user?

  private

  def session_store
    @session_store ||= SessionStore.new(session)
  end

  def authenticate_user
    unless current_user?
      redirect_to root_path
    end
  end

  def current_user?
    @has_current_user ||= Users.user?(session_store: session_store)
  end

  def current_user
    @current_user ||= Users.get_current_user(
      store: UserRecord,
      session_store: session_store
    )
  end
end
