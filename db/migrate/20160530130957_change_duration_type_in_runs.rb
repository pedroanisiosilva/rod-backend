class ChangeDurationTypeInRuns < ActiveRecord::Migration
  def change
  	change_column :runs, :duration, 'integer USING CAST("duration" AS integer)'
  end
end