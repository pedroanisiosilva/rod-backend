class Api::V1::RodImageSerializer < Api::V1::BaseSerializer
	attributes :image_file_name, :caption, :id
  	belongs_to :run
end

