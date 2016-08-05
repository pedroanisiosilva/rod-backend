require "rails_helper"

describe "week status", :type=> :feature do

  	scenario '.has the right number of active user per week' do
		user_a = create(:user)
		user_b = create(:user)
		user_c = create(:user)
		user_d = create(:user)
		user_d.weekly_goal.delete

		visit week_status_index_path
		header = page.response_headers['Content-Type']
     	expect(page).to have_content('3 🏃')
    end

    scenario 'generate image' do
    	visit '/week_status/31/red/image.png'
    	byebug
    	expect(page.response_headers['Content-Type']).to eq("image/png; charset=utf-8")
    	expect(page.response_headers['Content-Length'].to_i).to be > 0
    end
end

