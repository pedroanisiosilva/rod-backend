class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.datetime :datetime
      t.decimal :distance
      t.time :duration

      t.timestamps null: false
    end
  end
end
