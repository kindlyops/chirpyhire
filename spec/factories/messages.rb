FactoryGirl.define do
  factory :message do
    association :messageable, factory: :candidate
    sid { Faker::Internet.password(34) }
  end
end
