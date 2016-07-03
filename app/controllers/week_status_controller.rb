
class WeekResults
end


class WeekStatusController < ApplicationController
  include ApplicationHelper

  # GET /week_status
  # GET /week_status.json


def index

	categories = Hash.new
	categories = {"Extreme Black" => "+450km", "Extreme Red" => "+350km", "Black" => "+250km",
        "Red" => "+200km","Purple" => "+150km","Blue" => "+100km", "Green" => "+75km",
        "Orange" => "+50km", "Yellow" => "+25km", "White" => "0-24km"}

  @result = Hash.new

  if params[:week_number].nil?
    week = Time.zone.now.at_beginning_of_week.strftime("%W").to_i
  else
    week = params[:week_number].to_i
  end

  range_date = Date.commercial(Time.zone.now.year.to_i, week)

  if range_date.beginning_of_week.month != range_date.end_of_week.month
    filter_date = Time.zone.now
  else
    filter_date = range_date
  end

  nan_speed = 1000000

    if params[:belt]
      speed_hash = Hash.new

    	belt = params[:belt].capitalize
			runners = User.group('users.id').joins(:categories).includes(:runs).select('users.id,users.name,status').where(["categories.name = ? and categories.first_day = ?", belt, filter_date.at_beginning_of_month])
			self.delete_from_relation_if_no_goal(runners,range_date)

      runners.each do |runner|
        total_distance = runner.weekly_runs_km_on_date(range_date)
        total_duration = runner.weekly_runs_duration_on_date(range_date)
        speed = total_duration/total_distance
        if speed.nan?
          nan_speed=nan_speed+0.01
          speed = nan_speed
        end
        speed_hash[speed] = runner
      end

      @result[belt] = Hash[speed_hash.sort].values

    else

		  categories.each do |key, value|
        speed_hash = Hash.new


  			runners = User.group('users.id').joins(:categories).includes(:runs).select('users.id,users.name,status').where(["categories.name = ? and categories.first_day = ?", key, filter_date.at_beginning_of_month])
  			self.delete_from_relation_if_no_goal(runners,range_date)

        runners.each do |runner|
          total_distance = runner.weekly_runs_km_on_date(range_date)
          total_duration = runner.weekly_runs_duration_on_date(range_date)
          speed = total_duration/total_distance
        if speed.nan?
          nan_speed=nan_speed+0.01
          speed = nan_speed
        end
          speed_hash[speed] = runner
        end

  			@result[key] = Hash[speed_hash.sort].values

		  end    	
    end
  end

  def delete_from_relation_if_no_goal (runners,date)
    runners.to_a.delete_if {|runner| runner.weekly_goal_on_date(date).nil?}
  end

end