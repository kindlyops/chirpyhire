FactoryGirl.define do
  factory :contact_stage do
    organization
    name { Faker::Name.name }

    trait :screened do
      name { 'Screened' }
    end

    trait :new do
      name { 'New' }
    end
  end
end
