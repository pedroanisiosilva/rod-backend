class Api::V1::SessionsController < Devise::SessionsController
  protect_from_forgery with: :reset_session
  skip_before_filter :verify_authenticity_token
  prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  before_filter :ensure_params_exist, :set_default_response_format
  respond_to :json
  before_filter :use_dummy_session  

  def use_dummy_session
  return unless request.format.json?
    # env["rack.session"] = {}
    request.session_options[:skip] = true
  end
  
  def create
    resource = User.find_for_database_authentication(:email => params[:email])

    #logger.debug "Resource attributes hash: #{resource.inspect}"

    return invalid_login_attempt unless resource

    if resource.valid_password?(params[:password])
      sign_in("user", resource)
      resource.ensure_authentication_token
      render :json=> {:success=>true, :auth_token=>resource.authentication_token, :email=>resource.email}
      return
    end
    invalid_login_attempt
  end

  def destroy
    sign_out(resource_name)
  end

  protected
  def ensure_params_exist
    return unless params[:email].blank?
    render :json=>{:success=>false, :message=>"missing user_login parameter"}, :status=>422
  end

  def invalid_login_attempt
    warden.custom_failure!
    render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
  end

  def set_default_response_format
    request.format = :json
  end    
end