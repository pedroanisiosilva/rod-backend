require "rails_helper"

RSpec.describe "Users route",  :type => :routing  do

	scenario "User cannot be deleted" do
		user = create(:user)
		expect(:delete => %{"/users/"#{user.id}}).not_to be_routable
	end

end

