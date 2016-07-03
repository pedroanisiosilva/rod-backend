class UserStatsController < ApplicationController
  # GET /week_status
  # GET /week_status.json

def index
	 @user = User.find(params[:id])
end

def indexxx

	categories = Hash.new
	categories = {"Extreme Black" => "+450km", "Extreme Red" => "+350km", "Black" => "+250km",
        "Purple" => "+150km","Blue" => "+100km", "Green" => "+75km",
        "Orange" => "+50km", "Yellow" => "+25km", "White" => "0-24km"}

    @result = Hash.new

    if params[:belt]

    		belt = params[:belt].capitalize
			runners = User.group('users.id').joins(:categories).includes(:runs).select('users.id,users.name').where(["categories.name = ?", belt])
			runners = runners.sort { |a,b| a.runs.where(:datetime => Time.zone.now.beginning_of_week..Time.zone.now.end_of_week).sum(:distance).to_i<=> b.runs.where(:datetime => Time.zone.now.beginning_of_week..Time.zone.now.end_of_week).sum(:distance).to_i}
			runners = runners.reverse
			@result[belt] = runners    	
    else
		categories.each do |key, value|

			runners = User.group('users.id').joins(:categories).includes(:runs).select('users.id,users.name').where(["categories.name = ?", key])
			runners = runners.sort { |a,b| a.runs.where(:datetime => Time.zone.now.beginning_of_week..Time.zone.now.end_of_week).sum(:distance).to_i<=> b.runs.where(:datetime => Time.zone.now.beginning_of_week..Time.zone.now.end_of_week).sum(:distance).to_i}
			runners = runners.reverse
			@result[key] = runners

		end    	
    end
  end
end