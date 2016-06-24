require "rails_helper"


RSpec.describe "Generate Weekly goal job"  do

  	scenario '.when runner fail in previus go' do
		user = create(:user)
		user.weekly_goal.delete
		last_week = 1.week.ago.at_beginning_of_week

		goal = create(:weekly_goal, :user => user, :first_day => last_week, :last_day => last_week.at_end_of_week, :number => last_week.at_beginning_of_week.strftime("%W").to_i, :distance => 8)
		pp goal

  		first_run = create(:run, :distance =>'4',:duration=>'3600', :user =>user, :datetime => 1.week.ago.at_beginning_of_week)
  		# second_run = create(:run, :distance =>'12',:duration=>'3600', :user =>user)
  		# third_run = create(:run, :distance =>'12',:duration=>'3600', :user => user)

  		pp [user.weekly_goal_on_date(Date.today-8)]
  		goal.simple_target

     	expect(user.weekly_goal_on_date(last_week).distance.to_f).to eq(4)
    end
end