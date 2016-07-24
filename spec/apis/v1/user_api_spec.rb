require "rails_helper"

RSpec.feature "User" do

	context "api" do

		scenario "access user stats" do

			user = create(:user, :name => "Pedro")
			login_as user, :scope => :user			

			visit(%{#{api_v1_user_url(user)}})
			pp page
			expect(page).to have_content(%{"run_count":0})
		end

	end
end