# frozen_string_literal: true
FactoryGirl.define do
  factory :template do
    organization
    sequence(:name) { |i| "#{Faker::Lorem.words(rand(1..3)).join}#{i}" }
    sequence(:body) { |i| "#{Faker::Lorem.paragraph(rand(1..5))}#{i}" }
  end
end
