class SessionStore
  def initialize(session)
    @session = session
  end

  def user_id
    session[:user_id]
  end

  def user_id?
    !!session[:user_id]
  end

  def save_user_id(id)
    session[:user_id] = id
  end

  def remove_user_id
    session[:user_id] = nil
  end

  private

  attr_reader :session
end
