FactoryGirl.define do
  factory :goal do
    body { Faker::Lorem.sentence }
    contact_stage
  end
end
