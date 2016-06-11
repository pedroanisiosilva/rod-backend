FactoryGirl.define do

	sequence(:email) { |n| "person-#{n}@example.com" }

	factory :user do

    	name Forgery::Name.full_name
    	email :email
    	time_zone 'Brasilia'
  	end
end