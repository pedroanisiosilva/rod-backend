class RunMessagesWorker
	include Sidekiq::Worker
	sidekiq_options :retry => 0
	include ActionView::Helpers::DateHelper
  
	def perform(run_id)
		@run = Run.find(run_id)
		@user = @run.user
		send_create_congrats(@run)
		#start sending after 2 weeks of user creation
		if (Date.today - Date.parse(@run.user.created_at.to_s)).to_i > 14 
			send_max_distance
			send_max_duration
			send_max_speed
			send_distance_max_speed(5)
			send_distance_max_speed(8)
			send_distance_max_speed(10)
			send_distance_max_speed(16)		
			send_distance_max_speed(21)
			send_distance_max_speed(42)
		end
		
		if Date.today.saturday? || Date.today.sunday?
		 	check_if_did_meet_goal
		end
	end

	def send_create_congrats(run)
	  	msg_array = Array.new
	  	msg_array[0] = "👏👏👏 #{short_name(run.user.name)} correu #{"%3.1f"%run.distance}Km a #{run.pace} min/km #{time_relative(run.datetime)}"
		msg_array[1] = "Congrats!🏃 #{short_name(run.user.name)} correu #{"%3.1f"%run.distance}Km a #{run.pace} min/km #{time_relative(run.datetime)}👊"
		msg_array[2] = "🏃👏👏 #{short_name(run.user.name)} correu #{"%3.1f"%run.distance}Km a #{run.pace} min/km #{time_relative(run.datetime)}"
		msg_array[3] = "👏🎉🏃 #{short_name(run.user.name)} correu #{"%3.1f"%run.distance}Km a #{run.pace} min/km #{time_relative(run.datetime)}"
		msg_array[4] = "👏💪🎉🏃 #{short_name(run.user.name)} correu #{"%3.1f"%run.distance}Km a #{run.pace} min/km #{time_relative(run.datetime)}"
		msg_array[5] = "👊Congrats!🏃 #{short_name(run.user.name)} correu #{"%3.1f"%run.distance}Km a #{run.pace} min/km #{time_relative(run.datetime)}👊"
		msg_array[6] = "👊🏃💨 #{short_name(run.user.name)} correu #{"%3.1f"%run.distance}Km a #{run.pace} min/km #{time_relative(run.datetime)}👊"
		msg_array[7] = "👏🎉🏃🏃 #{short_name(run.user.name)} correu #{"%3.1f"%run.distance}Km a #{run.pace} min/km #{time_relative(run.datetime)}💪"
	
		run.user.groups.reject{|g|g.nil?}.each do |g|
			comunicator.send_msg(random_message(msg_array),run, g.telegram_id)
		end
	end

	def send_max_distance
	  	msg_array = Array.new
	  	msg_array[0] = "🌍 #{short_name(@run.user.name)} essa foi sua maior distancia #{"%3.1f"%@run.distance}Km"
		
	  	if  @user.runs.maximum(:distance).to_f == @run.distance.to_f
	  		@user.groups.reject{|g|g.nil?}.each do |g|
				comunicator.send_text_only(random_message(msg_array),g.telegram_id)
			end
		end
	end	

	def send_max_duration
	  	msg_array = Array.new
	  	msg_array[0] = "⌛️ #{short_name(@run.user.name)} essa foi sua corrida de maior duração #{@run.duration_formated}"
		
	  	if  @user.runs.maximum(:duration).to_i == @run.duration.to_f
	  		@user.groups.reject{|g|g.nil?}.each do |g|
				comunicator.send_text_only(random_message(msg_array),g.telegram_id)
			end
		end
	end		

	def check_if_did_meet_goal

		time_obj = Date.parse(Time.parse(Time.zone.now.to_s).strftime('%Y/%m/%d'))

		weekly_goal = WeeklyGoal.find_by(:first_day => time_obj.beginning_of_week, :user_id =>@user.id)
		runned_so_far = @user.weekly_runs_km

		msg_array = Array.new
		msg_array[0] = "🎯 #{short_name(@run.user.name)} acabou de bater a meta semanal: #{runned_so_far.to_f}km de #{weekly_goal.distance.to_f}km"		

		if runned_so_far.to_f >= weekly_goal.distance.to_f && (runned_so_far.to_f - @run.distance.to_f) < weekly_goal.distance.to_f
			@user.groups.reject{|g|g.nil?}.each do |g|
				comunicator.send_text_only(random_message(msg_array),g.telegram_id)
			end
		end
	end

	def send_distance_max_speed(run_distance)
		 msg_array = Array.new
		 msg_array[0] = "🏆🏃💨 #{short_name(@run.user.name)} fez seus #{run_distance}km mais rápidos: #{"%3.1f"%@run.speed.to_f} km/h"

		if @run.distance.to_f >= run_distance and @run.distance.to_f < run_distance+1

		  	same_distance_runs = @user.runs.where(%{distance >= #{run_distance} and distance < #{run_distance+1}})

		  	if  same_distance_runs.maximum(:speed).to_f == @run.speed.to_f
		  		@user.groups.reject{|g|g.nil?}.each do |g|
					comunicator.send_text_only(random_message(msg_array),g.telegram_id)
				end
			end			
		end
	end

	def send_max_speed
	  	msg_array = Array.new
	  	msg_array[0] = "🏃💨 #{short_name(@run.user.name)} fez sua corrida mais rápida #{"%3.1f"%@run.distance}Km a #{"%3.1f"%@run.speed.to_f} km/h"

	  	if  @user.runs.maximum(:speed).to_f == @run.speed.to_f
	  		@user.groups.reject{|g|g.nil?}.each do |g|
				comunicator.send_text_only(random_message(msg_array),g.telegram_id)
			end
		end
	end	

	def random_message(message_array)
		message_array[Random.rand(0..message_array.size-1)]
	end

	def comunicator
    	@comunicator ||= Comunicator::RodTelegram.new
    end

	def short_name(full_name)
		%{#{full_name.split(" ")[0]} #{full_name.split(" ")[-1]}}
	end  

	def time_relative(datetime)
		%{#{distance_of_time_in_words(datetime,Time.zone.now, :locale=> "pt-BR")} atrás} 
	end
end

