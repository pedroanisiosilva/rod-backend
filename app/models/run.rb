class Run < ActiveRecord::Base
	belongs_to :user, :validate => true
	validates_presence_of :distance
	validates_presence_of :user_id
	validates_presence_of :duration_formated

	def duration_formated=(new_duration)
	  self[:duration] = new_duration.split(':').map { |a| a.to_i }.inject(0) { |a, b| a * 60 + b}
	end	

	def duration_formated
		unless self.duration.nil?
			Time.at(self.duration).utc.strftime("%H:%M:%S")
		end
	end

	def datetime=(new_datetime)
		self[:datetime] = new_datetime
	end

	def speed
		(self.distance/(self.duration.to_f/3600)).round(2)
	end

	def pace
		pace = self.duration.to_f/self.distance
        mm, ss = pace.divmod(60)            #=> [4515, 21]
        hh, mm = mm.divmod(60)           #=> [75, 15]
        "%d:%02d" % [mm, ss]
	end

end


# t = 236 # seconds
# Time.at(t).utc.strftime("%H:%M:%S")
# => "00:03:56"

# "12:34:56".split(':').map { |a| a.to_i }.inject(0) { |a, b| a * 60 + b}
# # => 45296