FactoryGirl.define do

	sequence(:email) { |n| "person-#{n}@example.com" }

	factory :user do

    	name Forgery::Name.full_name
    	email "pedroanisio@me.com"
    	time_zone 'Brasilia'
    	password "734bds29rd"
  	end
end