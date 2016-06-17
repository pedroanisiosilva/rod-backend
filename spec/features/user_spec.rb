require "rails_helper"

RSpec.feature "User status" do

	context "when injured" do
		before do
			user = create(:user)
			user.status = "injured"
			user.save
			login_as user, :scope => :user

		end

		scenario "visit week_status" do		

			visit('/week_status/index')
			expect(page).to have_content("😷")
		end
	end

	context "when quitted" do
		before do
			user = create(:user)
			user.status = "quitted"
			user.save
			login_as user, :scope => :user

		end

		scenario "visit week_status" do		

			visit('/week_status/index')
			expect(page).to have_content("🚫")
		end

	end	
end