
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

	categories.each do |key, value|

		runners = User.group('users.id').joins(:categories).includes(:runs).select('users.id,users.name').where(["categories.name = ?", key])

		runners = runners.sort { |a,b| a.runs.where(:datetime => Date.today.beginning_of_week..Date.today.end_of_week).sum(:distance).to_i<=> b.runs.where(:datetime => Date.today.beginning_of_week..Date.today.end_of_week).sum(:distance).to_i}
		runners = runners.reverse
		# runners = User.joins("LEFT OUTER JOIN categories ON users.id = categories.user_id").where(["categories.name = ?", key])
		# runners = User.joins("LEFT OUTER JOIN runs ON users.id = runs.user_id").joins(:categories).where(["categories.name = ?", key])
		# runners = User.group('users.id').joins(:categories, :runs).select('users.id, users.name, coalesce(SUM(runs.distance),0) as total_distance').where(["categories.name = ?, key ,Date.today.beginning_of_week,Date.today.end_of_week]).order("total_distance DESC")

		@result[key] = runners

	end
  end
end