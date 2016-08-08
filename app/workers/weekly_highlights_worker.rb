class WeeklyHighlightsWorker
	include Sidekiq::Worker
  
	def perform
		@begin_date 		= 1.week.ago.beginning_of_week
		@end_date			= 1.week.ago.end_of_week	
		week_set			= Run.where(:datetime => @begin_date ..@end_date)
		@week_high_lights	= Highlight.new(week_set)

		@msg = "Destaques da semana!!"
		build_high_lights_msg
		comunicator.send_text_only(@msg)
	end

	def build_high_lights_msg
		@msg = @msg + "\n"+ fast_run(@week_high_lights.fastest_run)
		@msg = @msg + "\n"+ farthest_run(@week_high_lights.farthest_run)
		@msg = @msg + "\n"+ hookie(@week_high_lights.hookie)
		if (@end_date - @begin_date)/24/60/60.round <8
			@msg = @msg + "\n"+ target_smasher(@week_high_lights.target_smasher)
		end
		@msg = @msg + "\n"+ latest_and_earliest(@week_high_lights.latest_and_earliest)
		@msg = @msg + "\n"+ run_count_smasher(@week_high_lights.run_count_smasher)
		@msg = @msg + "\n"+ weely_half_marathon(@week_high_lights.run_at_distance(21))	
	end

	def fast_run(run)
		unless run.nil?
			msg_array = Array.new
		  	msg_array[0] = %{⚡️ Mais rápida: #{short_name(run.user.name)} - #{run.distance.to_f}km - #{run.pace}min/km}
		  	random_message(msg_array)			
		else
			return ""			
		end
	end

	def farthest_run(run)
		unless run.nil?
			msg_array = Array.new
		  	msg_array[0] = %{🌍 Maior distância: #{short_name(run.user.name)} - #{run.distance.to_f}km}
		  	random_message(msg_array)			
		else
			return ""			
		end

	end

	def hookie(runner)
		unless runner.nil?
			msg_array = Array.new
		  	msg_array[0] = %{👶 Novato(a) destaque: #{short_name(runner.name)} - #{runner.weekly_runs_km_on_date(@begin_date).to_f}km}
		  	random_message(msg_array)			
		else
			return ""			
		end
	end

	def target_smasher(runner)
		unless runner.nil?
			msg_array = Array.new
		  	msg_array[0] = %{📈 Maior superação meta: #{short_name(runner.name)} - #{((runner.weekly_runs_km_on_date(@begin_date)/runner.weekly_goal_on_date(@begin_date).distance.to_f)*100).round(0)}%}
		  	random_message(msg_array)			
		else
			return ""			
		end
	end

	def latest_and_earliest(run_hash)
		unless run_hash.nil?
			earliest 	= run_hash['earliest']
			latest 		= run_hash['latest']
			msg_array = Array.new
		  	msg_array[0] = %{🌚 Corrida mais tarde: #{short_name(latest.user.name)} - #{latest.datetime.strftime("%d/%m/%Y %H:%M")}\n🌞 Corrida mais cedo: #{earliest.user.name} - #{earliest.datetime.strftime("%d/%m/%Y %H:%M")}}
		  	random_message(msg_array)
		else
			return ""			
		end
	end

	def run_count_smasher(runner)
		unless runner.nil?
			msg_array = Array.new
		  	msg_array[0] = %{➕ Maior qtd de corridas: #{short_name(runner.name)} - #{runner.weekly_runs_count_on_date(@begin_date)}}
		  	random_message(msg_array)
		else
			return ""			
		end	
	end

	def weely_half_marathon(runners_set)
		unless runners_set.size == 0
			runners = ""

			runners_set.each_with_index do |run,i|
				if i > 0
					runners = runners + %{, #{short_name(run.user.name)}} 
				else
					runners = runners + %{#{short_name(run.user.name)}}
				end
			end

			msg_array = Array.new
		  	msg_array[0] = %{2️⃣1️⃣ km - #{runners} - meia maratona semanal}
		  	random_message(msg_array)			
		else
			return ""			
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
end


