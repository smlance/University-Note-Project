module SessionsHelper

  def sign_in(user)
    # Generate a new remember_token for the user
    remember_token = User.new_remember_token
    # Place the remember_token in the cookie for this session
    cookies.permanent[:remember_token] = remember_token
    # Update the remember_token column in the database for this user
    # (i.e., place a _hashed_ version of the token in the database)
    user.update_attribute(:remember_token, User.digest(remember_token))
    # Change the session's current_user to this user (given as arg)
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.digest(User.new_remember_token))
    cookies.delete(:remember_token)
    # Setting current user to nil is not necessary, but it can
    # let us sign out without a redirect.
    # (We currently automatically redirect in the destroy action.)
    self.current_user = nil
  end

  # Set the current user
  def current_user=(user)
    @current_user = user
  end

  # Retrieve the current user
  def current_user
    remember_token = User.digest(cookies[:remember_token])
    # Find the user in the database if it's not currently stored 
    # as an instance variable. If it is, just return it (the instance
    # variable).
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end

  def signed_in_user
    unless signed_in?
      store_location
      # Store the location the user intended to go to if not
      # signed in (we will redirect him there later)
      redirect_to signin_url,
      notice: "Please sign in." unless signed_in?
      # This notice is a flash. This whole line is short for:
      # unless signed_in?
      #   flash[:notice] = "Please sign in."
      #   redirect_to signin_url
      # end
    end
  end

end
