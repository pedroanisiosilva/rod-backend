class RunObserver < ActiveRecord::Observer
  attr :comunicator



	def random_message(message_array)
		message_array[Random.rand(0..message_array.size-1)] 
	end

	  def after_create(run)

	  	new_run_congrats = Array.new
		new_run_congrats[0] = "👏👏👏 #{short_name(run.user.name)} correu #{"%3.1f"%run.distance}Km a #{run.pace} min/km"
		new_run_congrats[1] = "Congrats!🏃 #{short_name(run.user.name)} correu #{"%3.1f"%run.distance}Km a #{run.pace} min/km👊"
		new_run_congrats[2] = "🏃👏👏 #{short_name(run.user.name)} correu #{"%3.1f"%run.distance}Km a #{run.pace} min/km"
		new_run_congrats[3] = "👏🎉🏃 #{short_name(run.user.name)} correu #{"%3.1f"%run.distance}Km a #{run.pace} min/km"
		new_run_congrats[4] = "👏💪🎉🏃 #{short_name(run.user.name)} correu #{"%3.1f"%run.distance}Km a #{run.pace} min/km"
		new_run_congrats[5] = "👊Congrats!🏃 #{short_name(run.user.name)} correu #{"%3.1f"%run.distance}Km a #{run.pace} min/km👊"
		new_run_congrats[6] = "👊🏃💨 #{short_name(run.user.name)} correu #{"%3.1f"%run.distance}Km a #{run.pace} min/km👊"
		new_run_congrats[7] = "👏🎉🏃🏃 #{short_name(run.user.name)} correu #{"%3.1f"%run.distance}Km a #{run.pace} min/km💪"

	    comunicator.send_msg(random_message(new_run_congrats), run.rod_images.first)
	  end

	  def comunicator
	    @comunicator ||= Comunicator::RodTelegram.new
	  end

	def short_name(full_name)
		%{#{full_name.split(" ")[0]} #{full_name.split(" ")[-1]}}
	end
end


