class PasswordsController < Devise::PasswordsController
  skip_before_filter :verify_authenticity_token, :only => :create

  def create
  	super
  end
end