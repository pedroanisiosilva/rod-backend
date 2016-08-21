FactoryGirl.define do

	sequence(:email) { |n| "person-#{n}@example.com" }

	factory :user do
  		association :role, factory: :role
    	name Forgery::Name.full_name
    	email {generate(:email)}
    	time_zone 'Brasilia'
    	password "734bds29rd"

		after(:create) {|user| user.groups << FactoryGirl.create(:group) }      	
  	end

	
end