FactoryGirl.define do
  factory :membership do
    association :group
    association :user
    member_type 1
  end
end
