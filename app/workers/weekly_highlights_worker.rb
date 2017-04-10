class WeeklyHighlightsWorker
	include Sidekiq::Worker
  
	def perform

		@groups = Group.all.reject{|g|g.nil?}

		@groups.each do |group|
			@begin_date 		= 1.week.ago.beginning_of_week
			@end_date			= 1.week.ago.end_of_week	
			week_set			= Run.where(:datetime => @begin_date..@end_date, :user=>User.where(:id => Membership.select(:user_id).where(:group_id => group.id)))
			
			## Increvelmente, tem grupos que passa 1 semana e ninguem corre.
			if (week_set.size > 0)
				@week_high_lights	= Highlight.new(week_set)
				build_high_lights_msg
				comunicator.send_text_only(@msg,group.telegram_id)
			end
		end

	end

	def build_high_lights_msg

		highlights = Array.new

		highlights.push(%{Destaques da semana(##{@begin_date.strftime("%W")}): #{@begin_date.strftime("%d/%b")} - #{@end_date.strftime("%d/%b")}!!})
		highlights.push(fast_run(@week_high_lights.fastest_run))
		highlights.push(farthest_run(@week_high_lights.farthest_run))
		highlights.push(hookie(@week_high_lights.hookie))
		highlights.push(weely_half_marathon(@week_high_lights.run_at_distance(21)))
		highlights.push( target_smasher(@week_high_lights.target_smasher))
		highlights.push(latest_and_earliest(@week_high_lights.latest_and_earliest))
		highlights.push(run_count_smasher(@week_high_lights.run_count_smasher))

		@msg = highlights.reject { |h| h.length ==0 }.join("\n")
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
		  	msg_array[0] = %{🌚 Corrida mais tarde: #{short_name(latest.user.name)} - #{latest.datetime.strftime("%d/%m/%Y %H:%M")}\n🌞 Corrida mais cedo: #{short_name(earliest.user.name)} - #{earliest.datetime.strftime("%d/%m/%Y %H:%M")}}
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


