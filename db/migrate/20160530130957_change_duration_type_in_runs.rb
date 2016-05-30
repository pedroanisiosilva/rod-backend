class ChangeDurationTypeInRuns < ActiveRecord::Migration
  def change
  	change_column :runs, :duration, :integer
  end
end