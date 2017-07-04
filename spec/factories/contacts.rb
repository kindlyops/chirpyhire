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

    trait :complete do
      after(:create) do |contact|
        organization = contact.organization
        contact.update(subscribed: true)

        %w[Availability Experience Transportation Certification
           SkinTest LiveIn CprFirstAid DriversLicense].each do |klass|
          question = "BotMaker::Question::#{klass}".constantize.new(nil, rank: nil)
          tag_name = question.responses_and_tags.map { |_, tag, _| tag }.sample
          contact.tags << organization.tags.find_or_create_by(name: tag_name)
        end
        contact.tags << organization.tags.find_or_create_by(name: 'Screened')

        zipcodes = %i[30319 30324 30327 30328 30329
                      30338 30339 30340 30341 30342]

        zipcodes
          .select { |z| Zipcode.where(zipcode: z).empty? }
          .each { |z| create(:zipcode, z) }

        zipcode = zipcodes.sample.to_s
        ZipcodeFetcher.call(contact, zipcode)
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
