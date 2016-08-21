FactoryGirl.define do
  factory :activity do
    user_id 1
    group_id 1
    membership_id 1
    run_id 1
    event_type "MyString"
    note "MyText"
    is_public false
  end
end
