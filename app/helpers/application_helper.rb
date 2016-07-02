module ApplicationHelper
	def pace_helper(duration,distance)
		if duration > 0 && distance > 0
			pace = duration.to_f/distance
	        mm, ss = pace.divmod(60)            #=> [4515, 21]
	        hh, mm = mm.divmod(60)           #=> [75, 15]
	        return "%d:%02d" % [mm, ss]
	    else
	    	return "n/a"
	    end
	end

  def short_name(full_name)
    %{#{full_name.split(" ")[0]} #{full_name.split(" ")[-1]}}
  end

  def bootstrap_class_for flash_type
    case flash_type
      when "success"
        "alert-success" # Green
      when "error"
        "alert-danger" # Red
      when "alert"
        "alert-warning" # Yellow
      when "notice"
        "alert-info" # Blue
      else
        %{-#{flash_type.to_s}}
    end
  end

  def speed_from_seconds(distance,duration)
    (distance/(duration.to_f/3600)).round(2)
  end

  def speed_category(speed)
    if speed >= 17.1
      "peregrine_falcon"
    elsif speed >= 15 && speed < 17.1
      "golden_eagle"
    elsif speed >= 13.3 && speed < 15
      "cheetah"
    elsif speed >= 12 && speed < 13.3
      "ostrish"
    elsif speed >= 10.9 && speed < 12
      "pronghorn_antelope"
    elsif speed >= 10 && speed < 10.9
      "blue_wildebeest"    
    elsif speed >= 9.2 && speed < 10
      "brown_hare"
    elsif speed >= 8.6 && speed < 9.2
      "red_fox"
    elsif speed >= 7.5 && speed < 8.6
      "mustang_horse"
    elsif speed < 7.5 && speed > 0
      "black_manba_snake"
    else
      "none"
    end 
  end 
	
end
