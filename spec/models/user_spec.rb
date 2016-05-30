require "rails_helper"

RSpec.describe User, :type => :model do

  it "Can't register without email" do
  	    expect {User.create!(name: "David")}.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "Name must be David" do
  	user = User.create!(name: "David", email:'david@uol.com.br')
    expect(user.name).to eq("David")
  end
end