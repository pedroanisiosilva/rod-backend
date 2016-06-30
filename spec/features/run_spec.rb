require "rails_helper"
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

RSpec.feature "Run" do

	scenario "Simply create run" do
		user = create(:user)
		login_as user, :scope => :user
		visit('/runs/new')
		# select user.name, :from => 'User'
		select_date("2016,June,10", :from => "Datetime")
		select_time(15,45, :from => "Datetime")		
		fill_in('Distance', :with => '15.6')
		fill_in('run_duration',:with => '01:30:00')

		click_button('Create Run')
		expect(page).to have_content('Run was successfully created')

	end

	scenario "Create run for Brasilia Time Zone" do
		user = create(:user)
		login_as user, :scope => :user

		visit('/runs/new')
		#save_and_open_page
		#select user.name, :from => 'User'
		select_date("2016,June,10", :from => "Datetime")
		select_time(15,45, :from => "Datetime")		
		fill_in('Distance', :with => '15.6')
		fill_in('run_duration',:with => '01:30:00')
		click_button('Create Run')
		#save_and_open_page
		expect(page).to have_content('15:45 BRT')
	end

	scenario "Create run for Pacific Time (US & Canada) Time Zone" do
		user = create(:user)
		user.time_zone = 'Pacific Time (US & Canada)'
		user.save
		login_as user, :scope => :user

		visit('/runs/new')
		#save_and_open_page
		#select user.name, :from => 'User'
		select_date("2016,June,10", :from => "Datetime")
		select_time(15,45, :from => "Datetime")		
		fill_in('Distance', :with => '15.6')
		fill_in('run_duration',:with => '01:30:00')
		click_button('Create Run')
		#save_and_open_page
		expect(page).to have_content('15:45 PDT')
	end

	scenario ".can have notes" do

		user = create(:user)
		login_as user, :scope => :user		

		visit('/runs/new')
		#save_and_open_page
		#select user.name, :from => 'User'
		select_date("2016,June,10", :from => "Datetime")
		select_time(15,45, :from => "Datetime")		
		fill_in('Distance', :with => '15.6')
		fill_in('run_duration',:with => '01:30:00')
		fill_in('Note',:with => 'Bla bla bla')
		click_button('Create Run')
		expect(page).to have_content('Bla bla bla')
	end


end
