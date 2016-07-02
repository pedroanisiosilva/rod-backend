
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
    week = Date.today.at_beginning_of_week.strftime("%W").to_i
  else
    week = params[:week_number].to_i
  end

  range_date = Date.commercial(Time.now.year.to_i, week)

  if range_date.beginning_of_week.month != range_date.end_of_week.month
    filter_date = Date.today
  else
    filter_date = range_date
  end

    if params[:belt]

    	belt = params[:belt].capitalize
			runners = User.group('users.id').joins(:categories).includes(:runs).select('users.id,users.name,status').where(["categories.name = ? and categories.first_day = ?", belt, filter_date.at_beginning_of_month])
			self.delete_from_relation_if_no_goal(runners,range_date)
      runners = runners.sort { |a,b| a.runs.where(:datetime => range_date.beginning_of_week..range_date.end_of_week).sum(:distance).to_i<=> b.runs.where(:datetime => range_date.beginning_of_week..range_date.end_of_week).sum(:distance).to_i}
			runners = runners.reverse
			@result[belt] = runners    	

    else

		  categories.each do |key, value|

  			runners = User.group('users.id').joins(:categories).includes(:runs).select('users.id,users.name,status').where(["categories.name = ? and categories.first_day = ?", key, filter_date.at_beginning_of_month])
  			self.delete_from_relation_if_no_goal(runners,range_date)
        runners = runners.sort { |a,b| a.runs.where(:datetime => range_date.beginning_of_week..range_date.end_of_week).sum(:distance).to_i<=> b.runs.where(:datetime => Date.today.beginning_of_week..range_date.end_of_week).sum(:distance).to_i}
  			runners = runners.reverse
  			@result[key] = runners

		  end    	
    end
  end

  def delete_from_relation_if_no_goal (runners,date)
    runners.to_a.delete_if {|runner| runner.weekly_goal_on_date(date).nil?}
  end

end