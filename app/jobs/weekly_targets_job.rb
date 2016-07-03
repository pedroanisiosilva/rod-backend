# class WeeklyTargetsJob < ActiveJob::Base
#   queue_as :default

# 	def simple_target

# 		## same last week if above target
# 		## last week *1.1 if bellow target
# 		## minimum 8km
# 	    tomorrow = Date.tomorrow
# 	    users = User.active

# 	    users.each do | user |

# 		    if user.weekly_runs_km >= user.weekly_goal.distance
# 		    	new_target = "%2.0f"%user.weekly_runs_km
# 		    else
# 		    	if user.weekly_runs_km < 8
# 		    		new_target = 8
# 		    	else
# 		    		new_target = "%2.0f"%user.weekly_runs_km*1.1
# 		    	end
# 		    end   	

# 			WeeklyGoal.create(first_day:tomorrow.at_beginning_of_week, last_day: tomorrow.at_end_of_week, number: tomorrow.at_beginning_of_week.strftime("%W").to_i, distance:new_target, user_id:user.id)
# 	  	end
# 	end

# 	def perform(*args)
#     # Do something later
# 		self.simple_target
#  	end

# end

# WeeklyTargetsJob.set(wait_until: Time.zone.now.noon).perform_later

