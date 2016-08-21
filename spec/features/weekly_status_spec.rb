require "rails_helper"

describe "week status", :type=> :feature do

  	scenario '.has the right number of active user per week' do
		user_a = create(:user)
		user_b = create(:user)
		user_c = create(:user)
		user_d = create(:user)
		user_d.weekly_goal.delete

    group     = create(:group, :name=>"RoD")
    membership_a  = create(:membership,:user=>user_a,:group=>group)
    membership_b  = create(:membership,:user=>user_b,:group=>group)
    membership_c  = create(:membership,:user=>user_c,:group=>group)
    membership_d  = create(:membership,:user=>user_d,:group=>group) 

    login_as user_a, :scope => :user
    visit(%{/week_status/#{group.id}/#{Date.today.strftime("%W")}})
	header = page.response_headers['Content-Type']
    expect(page).to have_content('3 🏃')
    end

    scenario 'generate image' do
    	visit '/week_status/1/image.png'
    	expect(page.response_headers['Content-Type']).to eq("application/octet-stream")
    	expect(page.response_headers['Content-Length'].to_i).to be > 0
    end
end

