FactoryGirl.define do
  factory :contact do
    phone_number { Faker::PhoneNumber.cell_phone }
    association :person
    organization
    association :stage, factory: :contact_stage

    trait :engaged do
      after(:create) do |contact|
        create(:conversation, :message, contact: contact)
      end
    end

    trait :name do
      name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    end

    trait :new do
      association :stage, :new, factory: :contact_stage
    end

    after(:create) do |contact|
      if contact.phone_number.present?
        contact.person.update(phone_number: contact.phone_number)
      end
    end

    trait :subscribed do
      subscribed { true }
    end

    trait :complete do
      name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
      after(:create) do |contact|
        organization = contact.organization
        stage = organization.contact_stages.find_or_create_by(name: 'Scheduled')
        contact.update(subscribed: true, stage: stage)
        BotFactory::Maker.questions.without('Zipcode').each do |klass|
          question = "BotFactory::Question::#{klass}".constantize.new(nil, rank: nil)
          tag_name = question.responses_and_tags.map { |_, tag, _| tag }.sample
          contact.tags << organization.tags.find_or_create_by(name: tag_name)
        end

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
