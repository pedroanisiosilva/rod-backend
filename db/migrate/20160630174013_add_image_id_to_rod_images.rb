class AddImageIdToRodImages < ActiveRecord::Migration
  def change
    add_column :rod_images, :images_id, :integer
  end
end
