require "rails_helper"

RSpec.feature "Activity" do

	before(:all) do
		@user = create(:user)
	end

  	scenario 'is logging when injuries start' do
  		@user.injured!
  		acitivities = Activity.last;
  		expect(acitivities.event_type).to eq('user_injured')
    end   

end