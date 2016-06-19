require "rails_helper"

RSpec.feature "Admin" do

  	scenario '.can download XLS' do
		user = create(:user)
		login_as user, :scope => :user	  		

  		first_run = create(:run, :distance =>'10',:duration=>'3600')
  		second_run = create(:run, :distance =>'12',:duration=>'3600')
  		third_run = create(:run, :distance =>'12',:duration=>'3600')

		visit runs_path
		click_on 'XLS'
		header = page.response_headers['Content-Type']
		#pp page.response_headers
		#header.should match /^application\/xls/
     	expect(header).to match /^application\/xls/
    end
end