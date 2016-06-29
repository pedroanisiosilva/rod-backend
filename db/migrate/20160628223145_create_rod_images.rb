class CreateRodImages < ActiveRecord::Migration
  def change
    create_table :rod_images do |t|
      t.string :caption
      t.attachment :image

      t.timestamps null: false
    end
  end
end
