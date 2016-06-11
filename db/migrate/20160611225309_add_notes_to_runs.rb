class AddNotesToRuns < ActiveRecord::Migration
  def change
  	add_column :runs, :note, :text
  end
end
