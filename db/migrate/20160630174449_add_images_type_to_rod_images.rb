class AddImagesTypeToRodImages < ActiveRecord::Migration
  def change
    add_column :rod_images, :images_type, :string
  end
end
