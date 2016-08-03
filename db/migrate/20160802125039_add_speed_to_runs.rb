class AddSpeedToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :speed, :decimal

    Run.reset_column_information 

    runs = Run.all

    runs.each do |r|
       r.speed = (r.distance/(r.duration.to_f/3600)).round(2)
       r.save
    end  	
  end
end