FactoryGirl.define do

  factory :weekly_goal do
  	association :user, factory: :user
	first_day Date.today.at_beginning_of_week
	last_day  Date.today.at_end_of_week
	number Date.today.at_beginning_of_week.strftime("%W").to_i
	distance 8    
  end
end

