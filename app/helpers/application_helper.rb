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

  def bootstrap_class_for flash_type
    case flash_type
      when :success
        "alert-success"
      when :error
        "alert-error"
      when :alert
        "alert-block"
      when :notice
        "alert-info"
      else
        flash_type.to_s
    end
  end
	
end
