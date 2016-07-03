class WeeklyGoal < ActiveRecord::Base
  belongs_to :user

	def simple_target

		## same last week if above target
		## last week *1.1 if bellow target
		## minimum 8km
	    tomorrow = Date.tomorrow
	    users = User.active

	    last_week = 1.week.ago.at_beginning_of_week

	    users.each do | user |

	    	last_week_performance = user.weekly_runs_km_on_date(last_week)
	    	last_week_goal = user.weekly_goal_on_date(Time.zone.now).distance.to_f

		    if last_week_performance >= last_week_goal

		    	new_target = "%2.0f"%last_week_performance
		    else
		    	if last_week_performance < 8
		    		new_target = 8
		    	else
		    		new_target = "%2.0f"%last_week_performance*1.1
		    	end
		    end   	

			WeeklyGoal.create(first_day:tomorrow.at_beginning_of_week, last_day: tomorrow.at_end_of_week, number: tomorrow.at_beginning_of_week.strftime("%W").to_i, distance:new_target, user_id:user.id)
	  	end
	end  
end
