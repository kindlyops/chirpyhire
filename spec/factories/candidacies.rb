FactoryGirl.define do
  factory :candidacy do
    person

    trait :with_subscriber do
      before(:create) do |candidacy|
        candidacy.subscriber = create(:subscriber, person: candidacy.person)
      end
    end
  end
end
