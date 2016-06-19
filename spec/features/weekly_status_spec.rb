require "rails_helper"

RSpec.feature "WeeklyStatus" do

  	scenario '.has the right number of active user per week' do
		user_a = create(:user)
		user_b = create(:user)
		user_c = create(:user)
		user_d = create(:user)
		user_d.weekly_goal.delete

		login_as user_a, :scope => :user	  		

		visit week_status_index_path
		header = page.response_headers['Content-Type']
		#header.should match /^application\/xls/
     	expect(page).to have_content('3 🏃')
    end
end