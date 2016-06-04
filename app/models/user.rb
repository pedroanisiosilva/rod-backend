class User < ActiveRecord::Base
	has_many :runs
	has_many :categories
	has_many :weekly_goals
	validates_presence_of :email

	def category
		self.category_on_date(Date.today)
	end

	def category_on_date(date)
		self.categories.where(first_day:date.at_beginning_of_month)[0]
	end


	def weekly_goal
		self.weekly_goal_on_date(Date.today)
	end

	def weekly_goal_on_date(date)
		self.weekly_goals.where(first_day:date.at_beginning_of_week)[0]
	end

end
