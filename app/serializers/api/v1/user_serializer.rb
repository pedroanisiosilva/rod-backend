class Api::V1::UserSerializer < Api::V1::BaseSerializer
  attributes :id, :email, :name,  :status, :role, :created_at, :updated_at, :total_ran_meters

  has_many :runs

  def role
    object.role.name
  end

  def total_ran_meters
    object.runs.sum(:distance)
  end

  def created_at
    object.created_at.in_time_zone.iso8601 if object.created_at
  end

  def updated_at
    object.updated_at.in_time_zone.iso8601 if object.created_at
  end
end
