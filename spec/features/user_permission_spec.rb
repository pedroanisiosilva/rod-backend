require "rails_helper"
require 'pp'
include Warden::Test::Helpers

def select_date(date, options = {})
  field = options[:from]
  base_id = find(:xpath, ".//label[contains(.,'#{field}')]")[:for]
  year, month, day = date.split(',')
  select year,  :from => "#{base_id}_1i"
  select month, :from => "#{base_id}_2i"
  select day,   :from => "#{base_id}_3i"
end

def select_time(hour, minute, options = {})
  field = options[:from]
  base_id = find(:xpath, ".//label[contains(.,'#{field}')]")[:for]
  select hour, :from => "#{base_id}_4i"
  select minute, :from => "#{base_id}_5i"
end

RSpec.feature "Runner profile" do


	scenario "as registered users can create run" do

		user = create(:user)
		login_as user, :scope => :user
		visit('/runs/new')
		select_date("2016,June,10", :from => "Datetime")
		select_time(15,45, :from => "Datetime")		
		fill_in('Distance', :with => '15.6')
		fill_in('run_duration_formated',:with => '01:30:00')
		click_button('Create Run')
		expect(page).to have_content('Run was successfully created')
	end	

	# scenario "as registered users cannot create run for another user" do

	# 	user = create(:user)
	# 	user_b = create(:user, :name => "Usain Bolt")
	# 	login_as user, :scope => :user
	# 	visit('/runs/new')
	# 	# select "Usain Bolt", :from => 'User'
	# 	select_date("2016,June,10", :from => "Datetime")
	# 	select_time(15,45, :from => "Datetime")		
	# 	fill_in('Distance', :with => '15.6')
	# 	fill_in('run_duration_formated',:with => '01:30:00')
	# 	click_button('Create Run')
	# 	expect(page).to_not have_content('Run was successfully created')
	# end		

	scenario "as admin users can create run for another user" do

		user = create(:user)
		user_b = create(:user, :name => "Usain Bolt")
		login_as user, :scope => :user
		visit('/runs/new')
		# select "Usain Bolt", :from => 'User'
		select_date("2016,June,10", :from => "Datetime")
		select_time(15,45, :from => "Datetime")		
		fill_in('Distance', :with => '15.6')
		fill_in('run_duration_formated',:with => '01:30:00')
		click_button('Create Run')
		expect(page).to have_content('Run was successfully created')
	end		

	scenario "as registered users cannot see other runners run" do
		user_a = create(:user, :name => "Zé das Colves")
		user_b = create(:user, :name => "Usain Bolt")

		run_number1 = create(:run,:user => user_a, :distance => 12, :duration =>60*60)
		run_number2 = create(:run,:user => user_a, :distance => 12, :duration =>60*60)
		run_number3 = create(:run,:user => user_a, :distance => 12, :duration =>60*60)
		run_number4 = create(:run,:user => user_b, :distance => 7, :duration =>60*60)

		login_as user_a, :scope => :user

		visit('/runs')
		#save_and_open_page

		expect(page).to_not have_content('Usain Bolt')
		expect(page).to have_content(user_a.name)
	end

	scenario "as admin users cannot see other runners run" do
		user_a = create(:user, :name => "Pedro Silva")
		r = create(:role, :name => "admin")
		#r = Role.find_by_name("admin")
		user_a.role_id = r.id
		user_a.save
		user_b = create(:user, :name => "Prefontaine")

		run_number1 = create(:run,:user => user_a, :distance => 12, :duration =>60*60)
		run_number2 = create(:run,:user => user_a, :distance => 12, :duration =>60*60)
		run_number3 = create(:run,:user => user_a, :distance => 12, :duration =>60*60)
		run_number4 = create(:run,:user => user_b, :distance => 7, :duration =>60*60)

		login_as user_a, :scope => :user

		visit('/runs')
		#save_and_open_page

		expect(page).to have_content('Prefontaine')
		expect(page).to have_content(user_a.name)

	end

end