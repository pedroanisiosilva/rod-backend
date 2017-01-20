class GoalGeneratorWorker
	include Sidekiq::Worker

	def perform

	    users					= User.active
	    @minimum_weekly_goal	= 6

	    users.each do | user |
	    	self.perform_better_algo(user)
	    end
	end

	def perform_better_algo(user)

		## For now, there is only one, but all improvements
		## will show-up here

		self.rule_of_thumb(user)
	end

	def rule_of_thumb(user)

		## if user meet target: 
		##    - new target will be an 10% increase over last target
		## if user looses target: 
		##    - new target will be an 20% decrease over last target

		today					= Time.now.utc.to_date
		last_week 				= 1.week.ago.at_beginning_of_week
    	last_week_performance	= user.weekly_runs_km_on_date(last_week)
    	last_week_goal 			= user.weekly_goal_on_date(last_week)

    	unless last_week_goal.nil?
    		last_week_goal = user.weekly_goal_on_date(last_week).distance.to_i
    	else
    		last_week_goal = 6
    	end

	    if last_week_performance >= last_week_goal
	    	new_target = "%2.0f"%(last_week_goal*1.1)
	    else
	    	new_target = "%2.0f"%(last_week_goal*0.8).to_i
	    end

	    if  new_target.to_i < @minimum_weekly_goal
	    	new_target = @minimum_weekly_goal
	    end 

		WeeklyGoal.create(first_day:today.at_beginning_of_week, last_day: today.at_end_of_week, number: today.at_beginning_of_week.strftime("%W").to_i, distance:new_target.to_i, user_id:user.id)

	end  


end