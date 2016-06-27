class Api::V1::BaseController < ActionController::Base
	acts_as_token_authentication_handler_for User, fallback_to_devise: false
	
	before_action :authenticate_user!
	skip_before_filter :verify_authenticity_token

	protect_from_forgery with: :null_session	
	before_filter :set_default_response_format

	private

	def set_default_response_format
		request.format = :json
	end  
end