class AddRunToRodImage < ActiveRecord::Migration
  def change
    change_table :rod_images do |t|
      t.references :run, index: true, foreign_key: true
    end
  end
end
