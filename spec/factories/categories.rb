FactoryGirl.define do
  factory :category do
    sequence(:name) { |n| "name#{n}" }
  end
end
