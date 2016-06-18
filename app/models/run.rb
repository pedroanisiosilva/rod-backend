class Run < ActiveRecord::Base
	belongs_to :user, :validate => true
	validates_presence_of :distance, :user_id, :duration_formated
	obfuscate_id

	def self.to_csv(options = {})
	  CSV.generate(options) do |csv|
	    csv << column_names
	    all.each do |run|
	      csv << run.attributes.values_at(*column_names)
	    end
	  end
	end

	def duration_formated=(new_duration)
	  self[:duration] = new_duration.split(':').map { |a| a.to_i }.inject(0) { |a, b| a * 60 + b}
	end	

	def duration_formated
		unless self.duration.nil?
			Time.at(self.duration).utc.strftime("%H:%M:%S")
		end
	end

	def in_user_time_zone(datetime)
		Time.zone = self.user.time_zone
		Time.zone.parse datetime.to_s
	end

	def datetime=(datetime)
		Time.zone = self.user.time_zone
		self[:datetime] = Time.zone.local_to_utc(datetime)
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
