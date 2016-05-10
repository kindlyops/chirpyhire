FactoryGirl.define do
  factory :notice do
    template

    trait :with_notification do
      after(:create) do |notice|
        create(:notification, notice: notice)
      end
    end
  end
end
