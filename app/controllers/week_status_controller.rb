
class WeekResults
end


class WeekStatusController < ApplicationController

  # GET /week_status
  # GET /week_status.json


def index

	categories = Hash.new
	categories = {"Extreme Black" => "+450km", "Extreme Red" => "+350km", "Black" => "+250km",
        "Purple" => "+150km","Blue" => "+100km", "Green" => "+75km",
        "Orange" => "+50km", "Yellow" => "+25km", "White" => "0-24km"}

  @result = Hash.new

  if params[:week_number].nil?
    week = Date.today.at_beginning_of_week.strftime("%U").to_i
  else
    week = params[:week_number]
  end

  range_date = Date.commercial(Time.now.year.to_i, week)

    if params[:belt]

    	belt = params[:belt].capitalize
			runners = User.group('users.id').joins(:categories).includes(:runs).select('users.id,users.name,status').where(["categories.name = ?", belt])
			runners = runners.sort { |a,b| a.runs.where(:datetime => range_date.beginning_of_week..range_date.end_of_week).sum(:distance).to_i<=> b.runs.where(:datetime => range_date.beginning_of_week..range_date.end_of_week).sum(:distance).to_i}
			runners = runners.reverse
			@result[belt] = runners    	

    else

		  categories.each do |key, value|

  			runners = User.group('users.id').joins(:categories).includes(:runs).select('users.id,users.name,status').where(["categories.name = ?", key])
  			runners = runners.sort { |a,b| a.runs.where(:datetime => range_date.beginning_of_week..range_date.end_of_week).sum(:distance).to_i<=> b.runs.where(:datetime => Date.today.beginning_of_week..range_date.end_of_week).sum(:distance).to_i}
  			runners = runners.reverse
  			@result[key] = runners

		  end    	
    end
  end
end