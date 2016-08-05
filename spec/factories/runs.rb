FactoryGirl.define do

  factory :run do
  	association :user, factory: :user
    duration 3600 + Random.rand(100500)
    distance 1+Random.rand(42)
    datetime Time.zone.now
  end
end