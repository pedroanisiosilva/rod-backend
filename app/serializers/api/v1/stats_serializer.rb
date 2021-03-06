class Api::V1::RunSerializer < Api::V1::BaseSerializer
  attributes :id, :distance, :duration, :speed, :note, :pace, :datetime
  belongs_to :user
  has_many :rod_images

  def pace
    object.pace
  end

  def id
  	object.id = object.to_param
  end

  def datetime
    object.datetime.utc.iso8601 if object.datetime
  end

  def created_at
    object.created_at.utc.iso8601 if object.created_at
  end

  def updated_at
    object.updated_at.utc.iso8601 if object.created_at

  end
end