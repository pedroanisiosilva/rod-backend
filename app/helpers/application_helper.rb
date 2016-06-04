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
end
