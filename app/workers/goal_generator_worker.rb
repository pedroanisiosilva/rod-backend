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

		new_target 	= @minimum_weekly_goal
		today		= Time.now.utc.to_date

		## For now, there is only one, but all improvements
		## will show-up here

		## get the consectuvies number of weeks
		## user is beeting the target
		number_of_weeks_on_target =	self.check_target_on_week(user,1,0)

		if number_of_weeks_on_target < 3
			new_target = self.rule_of_thumb(user)
		else
			new_target = self.goal_achiever(user,number_of_weeks_on_target)
		end

		new_target = "%2.0f"%new_target	

		WeeklyGoal.create(first_day:today.at_beginning_of_week, last_day: today.at_end_of_week, number: today.at_beginning_of_week.strftime("%W").to_i, distance:new_target.to_i, user_id:user.id)

	end

	def check_target_on_week(user,weeks_ago,current_spree)

		consecutive_weeks_on_target = current_spree
		previous_week 				= weeks_ago.week.ago.at_beginning_of_week		
		previous_week_goal 			= user.weekly_goal_on_date(previous_week)
		previous_week_real			= user.weekly_runs_km_on_date(previous_week)

    	unless previous_week_goal.nil?

			if previous_week_real >= previous_week_goal.distance.to_i

				consecutive_weeks_on_target+=1
				weeks_ago+=1
				consecutive_weeks_on_target = check_target_on_week(user,weeks_ago,consecutive_weeks_on_target)
					
			end
		end

		consecutive_weeks_on_target
	end

	def goal_achiever(user,number_of_weeks_on_target)

		## if user keeps toping its target
		## gets the medium of lats 4 weeks and adds 10%
		## not good, needs to improve

		max_recent_weeks = 4

		if number_of_weeks_on_target > max_recent_weeks
			number_of_weeks_on_target = max_recent_weeks
		end

		total_ran_distance = 0

		for week in 1..number_of_weeks_on_target
			previous_week 		=	week.week.ago.at_beginning_of_week
			total_ran_distance	+=	user.weekly_runs_km_on_date(previous_week)
		end

		mediam = total_ran_distance/number_of_weeks_on_target
		target = mediam*1.15
	end

	def rule_of_thumb(user)

		## if user meet target: 
		##    - new target will be an 10% increase over last target
		## if user looses target: 
		##    - new target will be an 20% decrease over last target

		last_week 				= 1.week.ago.at_beginning_of_week
    	last_week_goal 			= user.weekly_goal_on_date(last_week)
    	last_week_performance	= user.weekly_runs_km_on_date(last_week)
    	new_target 				= @minimum_weekly_goal

    	unless last_week_goal.nil?
    		last_week_goal = user.weekly_goal_on_date(last_week).distance.to_i
    	else
    		last_week_goal = @minimum_weekly_goal
    	end

	    if last_week_performance >= last_week_goal
	    	new_target = last_week_goal*1.1
	    else
	    	new_target = (last_week_goal*0.8).to_i
	    end

	    if  new_target.to_i < @minimum_weekly_goal
	    	new_target = @minimum_weekly_goal
	    end

	    new_target

	end  


end