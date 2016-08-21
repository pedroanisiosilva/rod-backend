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

	context "when update" do
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
			normal_user = create(:user)
			normal_user.save
			visit(user_path(normal_user))
			click_link('Edit')
			fill_in('Password', :with => 'pedroanisio')
			fill_in('Password confirmation', :with => 'pedroanisio')
			fill_in('Current password', :with =>'734bds29rd')
			#save_and_open_page
			click_button('Update User')
			expect(page).to have_content("successfully")
		end
	end
end

RSpec.feature "User status" do

	context "when injured" do

		url = ""

		before do
			user = create(:user)
			user.status = "injured"
			user.save
			login_as user, :scope => :user
			url = %{/week_status/#{user.groups.first.id}/#{Date.today.strftime("%W")}}
		end

		scenario "visit week_status" do

			visit(url)
			expect(page).to have_content("😷")
		end
	end

	context "when quitted" do
		scenario "visit week_status" do
			user = create(:user)
			user.status = "quitted"
			user.save
			login_as user, :scope => :user
			visit(%{/week_status/#{user.groups.first.id}/#{Date.today.strftime("%W")}})
			expect(page).to have_content("🚫")
		end

	end
end

RSpec.feature "restrict duplicate email" do

	it "on create" do
		create(:user, :email => "email1@email.com")
		expect(build(:user, :email => "email1@email.com")).to_not be_valid
	end

end
