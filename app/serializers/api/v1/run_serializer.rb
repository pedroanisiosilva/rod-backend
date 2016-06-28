class Api::V1::RunSerializer < Api::V1::BaseSerializer
  attributes :id, :distance, :duration, :speed, :note, :pace
  belongs_to :user

  def id
  	object.id = object.to_param
  end

  def created_at
    object.created_at.in_time_zone.iso8601 if object.created_at
  end

  def updated_at
    object.updated_at.in_time_zone.iso8601 if object.created_at
  end
end