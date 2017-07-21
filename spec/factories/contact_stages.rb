FactoryGirl.define do
  factory :contact_stage do
    organization
    name { Faker::Name.name }
  end
end
