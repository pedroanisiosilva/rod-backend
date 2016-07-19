class Api::V1::RodImageSerializer < Api::V1::BaseSerializer
	has_attached_file :image, include_nested_associations: true
	attributes :image_file_name, :caption, :id
  	belongs_to :run
end

