require "rails_helper"

RSpec.feature "User" do

	context "api" do

		scenario "show one user" do

			user = create(:user, :name => "Pedro")
			r = Role.new
			r.name = "admin"
			r.save
			user.role_id = r.id
			user.save
			login_as user, :scope => :user			

			visit(%{#{api_v1_user_url(user)}})
			expect(page).to have_content("Pedro")
		end

		scenario "show more than one user" do

			user = create(:user, :name => "Pedro")
			use_b = create(:user)
			r = Role.new
			r.name = "admin"
			r.save
			user.role_id = r.id
			user.save
			login_as user, :scope => :user			

			visit(%{#{api_v1_users_url}})
			expect(page).to have_content("Pedro")
		end

	end
end