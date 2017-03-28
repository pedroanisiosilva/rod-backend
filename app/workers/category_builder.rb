require 'open-uri'
require 'tempfile'
require 'faraday'

class CategoryBuilderWorker
	include Sidekiq::Worker
  
	def perform

		last_month	= DateTime.now.in_time_zone('Brasilia') -1.month
		users 		= User.active

		users.each do |user|

			belt = "White"

			total_distance = user.monthly_runs_km_on_date(last_month)

			if total_distance < 25
				belt = "White"
			elsif total_distance >= 25 && total_distance < 50
				belt = "Yellow"
			elsif total_distance >= 50 && total_distance < 75
				belt = "Orange"
			elsif total_distance >= 75 && total_distance < 100
				belt = "Green"
			elsif total_distance >= 10 && total_distance < 150
				belt = "Blue"
			elsif total_distance >= 150 && total_distance < 200
				belt = "Purple"
			elsif total_distance >= 200 && total_distance < 250
				belt = "Red"
			elsif total_distance >= 250
				belt = "Black"
			end
			
			c = Category.where(:user_id => user.id, :first_day => Date.today.at_beginning_of_month)

			if c.size == 0
				Category.create(first_day: Date.today.at_beginning_of_month, last_day: Date.today.at_end_of_month, name: belt,user_id:user.id)
			end
		end
	end
end



