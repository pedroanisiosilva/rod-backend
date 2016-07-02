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
	
end
