class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :type
      t.text :description
      t.date :start_date
      t.string :end_date
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
