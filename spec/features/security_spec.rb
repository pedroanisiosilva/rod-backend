require "rails_helper"
include Warden::Test::Helpers


RSpec.feature "Security Specs:" do

	scenario "registered users can't access group" do
		user 		= create(:user)
		group 		= create(:group, :name=>"RoD")
		membership 	= create(:membership,:user=>user,:group=>group)
		user.save
		group.save
		membership.save
		login_as user, :scope => :user
		visit(%{/groups/#{group.id}})
		expect(page).to have_content('You are not authorized to access this page.')
	end

end