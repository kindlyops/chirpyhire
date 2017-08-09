FactoryGirl.define do
  factory :campaign do
    organization
    name { Faker::Name.name }
    account
    association :last_edited_by, factory: :account
    last_edited_at { DateTime.current }
  end
end
