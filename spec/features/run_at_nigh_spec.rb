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
  before(:all) do
    ActiveRecord::Base.observers.disable :run_observer
  end

  after(:all) do
    ActiveRecord::Base.observers.enable :run_observer
  end

	scenario "Creat run neer midnight" do
		user = create(:user)
		login_as user, :scope => :user
		visit('/runs/new')
		select_date("2016,June,30", :from => "Datetime")
		select_time(21,50, :from => "Datetime")
		fill_in('Distance', :with => '15')
		fill_in('run_duration',:with => '01:30:00')
		click_button('Create Run')
		expect(page).to have_content('Run was successfully created')

		last_month = Date.parse('22-6-2016')
		total_distance = user.monthly_runs_km_on_date(last_month)
		expect(total_distance).to eq(15)
	end

	scenario "Create run for Brasilia Time Zone" do
		user = create(:user)
		login_as user, :scope => :user
		visit('/runs/new')
		#save_and_open_page
		#select user.name, :from => 'User'
		select_date("2016,June,30", :from => "Datetime")
		select_time(21,50, :from => "Datetime")
		fill_in('Distance', :with => '15')
		fill_in('run_duration',:with => '01:30:00')
		click_button('Create Run')
		#save_and_open_page
		expect(page).to have_content('21:50 BRT')
	end
end
