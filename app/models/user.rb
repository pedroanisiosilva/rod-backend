class User < ActiveRecord::Base
	has_many :runs
	has_many :categories
	has_many :weekly_goals
	validates_presence_of :email
	obfuscate_id

	def category
		self.category_on_date(Date.today)
	end

	def category_on_date(date)
		self.categories.find_by(:first_day => date.at_beginning_of_month)
	end

	def weekly_goal
		self.weekly_goal_on_date(Date.today)
	end

	def weekly_goal_on_date(date)
		self.weekly_goals.find_by(:first_day => date.at_beginning_of_week)
	end

	def weekly_runs_km
		self.weekly_runs_km_on_date(Date.today)
	end

	def weekly_runs_km_on_date(date)
		time_obj = Time.parse(date.to_s)
		self.runs.where(:datetime => time_obj.beginning_of_week..time_obj.end_of_week).sum(:distance).to_f
	end

	def weekly_runs_count
		self.weekly_runs_count_on_date(Date.today)
	end

	def weekly_runs_count_on_date(date)
		time_obj = Time.parse(date.to_s)
		self.runs.where(:datetime => time_obj.beginning_of_week..time_obj.end_of_week).count
	end	

	def weekly_runs_duration
		self.weekly_runs_duration_on_date(Date.today)
	end

	def weekly_runs_duration_on_date(date)
		time_obj = Time.parse(date.to_s)
		self.runs.where(:datetime => time_obj.beginning_of_week..time_obj.end_of_week).sum(:duration)
	end

	def monthly_runs_km
		self.monthly_runs_km_on_date(Date.today)
	end

	def monthly_runs_km_on_date(date)
		time_obj = Time.parse(date.to_s)
		self.runs.where(:datetime => time_obj.at_beginning_of_month..time_obj.end_of_month).sum(:distance).to_f
	end

	def monthly_runs_count
		self.weekly_runs_count_on_date(Date.today)
	end

	def monthly_runs_count_on_date(date)
		time_obj = Time.parse(date.to_s)
		self.runs.where(:datetime => time_obj.at_beginning_of_month..time_obj.end_of_month).count
	end	

	def monthly_runs_duration
		self.weekly_runs_duration_on_date(Date.today)
	end

	def monthly_runs_duration_on_date(date)
		time_obj = Time.parse(date.to_s)
		self.runs.where(:datetime => time_obj.at_beginning_of_month..time_obj.end_of_month).sum(:duration)
	end					

end
