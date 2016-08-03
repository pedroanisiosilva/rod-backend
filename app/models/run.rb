class Run < ActiveRecord::Base
	before_save :calculate_speed
	belongs_to :user, :validate => true
	validates_presence_of :distance, :user_id
	has_many :rod_images, :dependent => :destroy
	accepts_nested_attributes_for :rod_images, allow_destroy: true

	def self.to_csv(options = {})
	  CSV.generate(options) do |csv|
	    csv << column_names
	    all.each do |run|
	      csv << run.attributes.values_at(*column_names)
	    end
	  end
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

	def pace
		pace = self.duration.to_f/self.distance
        mm, ss = pace.divmod(60)            #=> [4515, 21]
        hh, mm = mm.divmod(60)           #=> [75, 15]
        "%d:%02d" % [mm, ss]
	end

	def calculate_speed
		self.speed = (self.distance/(self.duration.to_f/3600)).round(2)
	end
end
