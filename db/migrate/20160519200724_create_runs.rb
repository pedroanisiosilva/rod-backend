class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.datetime :datetime
      t.decimal :distance
      t.integer :duration

      t.timestamps null: false
    end
  end
end
