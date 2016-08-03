class Highlight
	def initialize (run_data_set)
		@data_set = run_data_set
		@runs
		@runners = User.where(id: @data_set.pluck(:user_id).uniq)
	end

	def fastest_run
		@data_set.order("speed DESC").first
	end

	def farthest_run
		@data_set.order("distance DESC").first
	end

	def longest_run
		@data_set.order("duration DESC").first
	end

	def run_at_distance(distance)
		@data_set.where("distance >= ? AND distance < ?",distance,distance+1)
	end

	def latest_and_earliest
		run_hash = Hash.new
		result_hash = Hash.new

		@data_set.each do |run|
			run_hash[run.datetime.strftime("%H%M%S%N")] = run
		end

		sorted_keys = run_hash.keys.sort

		result_hash['earliest']	= run_hash[sorted_keys.first]
		result_hash['latest']	= run_hash[sorted_keys.last]
		result_hash
	end

	def hookie
		freshman = @runners.where(:created_at => 2.week.ago.beginning_of_week..1.week.ago.end_of_week)
		real = freshman.each_with_index.map{|f,i| [f.weekly_runs_km_on_date(1.week.ago.beginning_of_week),i]}
		freshman[real.sort.last[1]]
	end

	def target_smasher
		metas = @runners.each_with_index.map{|f,i| [f.weekly_runs_km_on_date(1.week.ago.beginning_of_week)/f.weekly_goal_on_date(1.week.ago.beginning_of_week).distance.to_f,i]}
		@runners[metas.sort.last[1]]
	end

	def run_count_smasher
		metas = @runners.each_with_index.map{|f,i| [f.weekly_runs_count_on_date(1.week.ago.beginning_of_week),i]}
		@runners[metas.sort.last[1]]	
	end	

end