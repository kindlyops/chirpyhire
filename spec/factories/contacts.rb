FactoryGirl.define do
  factory :contact do
    association :person
    organization

    transient do
      phone_number nil
    end

    after(:create) do |contact, evaluator|
      if evaluator.phone_number.present?
        contact.person.update(phone_number: evaluator.phone_number)
      end
    end

    trait :"30341" do
      after(:create) do |contact|
        create(:zipcode, :"30341")
        ZipcodeFetcher.call(contact, '30341')
      end
    end

    trait :"30342" do
      after(:create) do |contact|
        create(:zipcode, :"30342")
        ZipcodeFetcher.call(contact, '30342')
      end
    end
  end
end
