class Api::V1::SessionSerializer < Api::V1::BaseSerializer
  #just some basic attributes
  attributes :id, :email, :name, :role, :token, :status

  def role
  	object.role.name
  end

  def token
    object.authentication_token
  end
end