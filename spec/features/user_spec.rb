require "rails_helper"

RSpec.feature "Admin" do

	context "when create" do
		before do
			user = create(:user)
			r = Role.new
			r.name = "admin"
			r.save
			user.role_id = r.id
			user.save
			login_as user, :scope => :user
		end

		scenario "other user" do

			visit('/users/new')
			fill_in('Name', :with => 'Pedro Anisio Silva')
			fill_in('Email', :with => 'pedroanisioxx@me.com')
			fill_in('Password', :with => 'pedroanisio')
			fill_in('Password confirmation', :with => 'pedroanisio')
			click_button('Create User')

			expect(page).to have_content("successfully")
		end
	end
end

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