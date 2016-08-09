FactoryGirl.define do
  factory :template do
    name { Faker::Lorem.words(3).join(" ") }
    body { Faker::Lorem.paragraph(rand(1..5)) }
  end
end
