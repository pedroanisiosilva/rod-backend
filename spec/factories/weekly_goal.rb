FactoryGirl.define do

  factory :weekly_goal do
  	association :user, factory: :user
	first_day Time.zone.now.at_beginning_of_week
	last_day  Time.zone.now.at_end_of_week
	number Time.zone.now.at_beginning_of_week.strftime("%W").to_i
	distance 8    
  end
end
