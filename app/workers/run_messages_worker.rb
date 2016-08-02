class RunMessagesWorker
	include Sidekiq::Worker
  
	def perform(run_id)
		@run = Run.find(run_id)
		@user = @run.user
		send_create_congrats(@run) #
		send_max_distance
		send_max_duration
	end

	def send_create_congrats(run)
	  	new_run_message = Array.new
	  	new_run_message[0] = "👏👏👏 #{short_name(run.user.name)} correu #{"%3.1f"%run.distance}Km a #{run.pace} min/km"
		new_run_message[1] = "Congrats!🏃 #{short_name(run.user.name)} correu #{"%3.1f"%run.distance}Km a #{run.pace} min/km👊"
		new_run_message[2] = "🏃👏👏 #{short_name(run.user.name)} correu #{"%3.1f"%run.distance}Km a #{run.pace} min/km"
		new_run_message[3] = "👏🎉🏃 #{short_name(run.user.name)} correu #{"%3.1f"%run.distance}Km a #{run.pace} min/km"
		new_run_message[4] = "👏💪🎉🏃 #{short_name(run.user.name)} correu #{"%3.1f"%run.distance}Km a #{run.pace} min/km"
		new_run_message[5] = "👊Congrats!🏃 #{short_name(run.user.name)} correu #{"%3.1f"%run.distance}Km a #{run.pace} min/km👊"
		new_run_message[6] = "👊🏃💨 #{short_name(run.user.name)} correu #{"%3.1f"%run.distance}Km a #{run.pace} min/km👊"
		new_run_message[7] = "👏🎉🏃🏃 #{short_name(run.user.name)} correu #{"%3.1f"%run.distance}Km a #{run.pace} min/km💪"
	
		comunicator.send_msg(random_message(new_run_message),run)
	end

	def send_max_distance
	  	max_running_distance_msg = Array.new
	  	max_running_distance_msg[0] = "🌍 #{short_name(@run.user.name)} essa foi sua maior distancia #{"%3.1f"%@run.distance}Km"
		
	  	if  @user.runs.maximum(:distance).to_f == @run.distance.to_f
			comunicator.send_text_only(random_message(max_running_distance_msg))
		end
	end	

	def send_max_duration
	  	max_running_duration_msg = Array.new
	  	max_running_duration_msg[0] = "⌛️ #{short_name(@run.user.name)} essa foi sua corrida de maior duração #{@run.duration_formated}"
		
	  	if  @user.runs.maximum(:duration).to_i == @run.duration.to_f
			comunicator.send_text_only(random_message(max_running_duration_msg))
		end
	end		

	#u.runs.where("distance > 10 and distance < 11")

	# def send_max_speed
	#   	max_running_pace_msg = Array.new
	#   	max_running_pace_msg[0] = "🏃💨 #{short_name(@run.user.name)} faz sua corrida mais rápida #{"%3.1f"%@run.distance}Km em #{@run.pace}"

	#   	if  @user.runs.maximum(:duration).to_i == @run.duration.to_f
	# 		comunicator.send_text_only(random_message(max_running_duration_msg))
	# 	end
	# end	

	def random_message(message_array)
		message_array[Random.rand(0..message_array.size-1)]
	end

	def comunicator
    	@comunicator ||= Comunicator::RodTelegram.new
    end

	def short_name(full_name)
		%{#{full_name.split(" ")[0]} #{full_name.split(" ")[-1]}}
	end  
end

