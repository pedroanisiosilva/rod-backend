class Api::V1::BaseController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :destroy_session
  acts_as_token_authentication_handler_for User

  def destroy_session
    request.session_options[:skip] = true
  end
end