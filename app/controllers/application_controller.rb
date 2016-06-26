class ApplicationController < ActionController::Base
  acts_as_token_authentication_handler_for User
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #check_authorization :unless => :devise_controller?
  #layout :layout

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def layout
    return "login_layout" if devise_controller?
    "application"
  end


end
