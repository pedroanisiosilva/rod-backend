class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.text :description
      t.string :locale
      t.float :geolat
      t.string :geolng
      t.boolean :is_public
      t.boolean :needs_admin_aproval

      t.timestamps null: false
    end
  end
end
