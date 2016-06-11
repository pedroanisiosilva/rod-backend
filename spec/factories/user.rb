FactoryGirl.define do
  factory :user do
    name "Pedro Silva"
    email	"pedroanisio@me.com"
    time_zone = Time.zone.to_s
  end
end