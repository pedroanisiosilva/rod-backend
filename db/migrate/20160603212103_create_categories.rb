class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.date :first_day
      t.date :last_day
      t.string :name
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
