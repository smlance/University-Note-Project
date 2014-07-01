class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper
  # We include the SessionsHelper so that methods defined in it
  # are accessible at any point in the application.
  # That is, they are available to all of the controllers.
  # (Normally, helpers are just available to viws.)

end
