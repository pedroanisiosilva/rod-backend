class Api::V1::UserSerializer < Api::V1::BaseSerializer
  attributes :id, :email, :name,  :status, :role, :created_at, :updated_at
  has_many :runs

  def role
    object.role.name
  end

  def created_at
    object.created_at.in_time_zone.iso8601 if object.created_at
  end

  def updated_at
    object.updated_at.in_time_zone.iso8601 if object.created_at
  end
end