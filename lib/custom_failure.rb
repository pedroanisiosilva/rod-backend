class CustomFailure < Devise::FailureApp
  def respond
    if request.format == :json || request.format.nil?
      Rails.logger.debug "Request attributes hash: #{request.inspect}"

      json_failure
    else
      #Rails.logger.debug "Request attributes hash: #{request.inspect}"
      #Rails.logger.debug "Request current format: #{request.format.to_s}"
      super
    end
  end

  def json_failure
    self.status = 401
    self.content_type = 'application/json'
    self.response_body = "{'error' : 'authentication error'}"
  end
end