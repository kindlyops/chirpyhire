FactoryGirl.define do
  factory :plan do
    stripe_id { "id_#{Faker::Lorem.characters(26)}" }
  end
end
