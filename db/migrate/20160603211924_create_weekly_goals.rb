class CreateWeeklyGoals < ActiveRecord::Migration
  def change
    create_table :weekly_goals do |t|
      t.date :first_day
      t.date :last_day
      t.integer :number
      t.references :user, index: true, foreign_key: true
      t.decimal :distance

      t.timestamps null: false
    end
  end
end
