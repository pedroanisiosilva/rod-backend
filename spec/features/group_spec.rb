require "rails_helper"
include Warden::Test::Helpers

RSpec.feature "Group" do

	scenario "create" do
		group 		= create(:group, :name=>"Run or Die")
		user		= create(:user)
		membership 	= create(:membership, :user=>user,:group=>group)
		expect(user.groups.where(:name=>"Run or Die").size).to eq(1)	
	end

	scenario "create factory as admin" do
		user		= create(:user)
		expect(user.memberships.last.member?).to eq(true)	
	end

	scenario "check for alias" do
		user		= create(:user)
		expect(user.groups.last.group_alias.size).to be >0	
	end

	scenario "list" do
		user = create(:user)
		r = Role.new
		r.name = "admin"
		r.save
		user.role_id = r.id
		login_as user, :scope => :user
		visit('/groups/')
		expect(page).to have_content('RoD')
	end	


end
