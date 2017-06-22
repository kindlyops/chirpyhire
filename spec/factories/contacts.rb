FactoryGirl.define do
  factory :contact do
    association :team, :inbox
    association :person

    transient do
      phone_number nil
    end

    after(:create) do |contact, evaluator|
      if evaluator.phone_number.present?
        contact.person.update(phone_number: evaluator.phone_number)
      end
      create(:contact_candidacy, contact: contact)
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

    trait :public_transportation do
      after(:create) do |contact|
        contact.contact_candidacy.update(transportation: :public_transportation)
      end
    end

    trait :personal_transportation do
      after(:create) do |contact|
        contact.contact_candidacy.update(transportation: :personal_transportation)
      end
    end

    trait :incomplete do
      after(:create) do |contact|
        candidacy = contact.contact_candidacy

        just_started = {
          contact: contact,
          certification: ContactCandidacy.certifications.keys.sample,
          inquiry: :availability
        }

        midway = {
          contact: contact,
          certification: ContactCandidacy.certifications.keys.sample,
          availability: ContactCandidacy.availabilities.keys.sample,
          live_in: [true, false].sample,
          experience: ContactCandidacy.experiences.keys.sample,
          inquiry: :transportation
        }

        zipcode = %w[30319 30324 30327 30328 30329
                     30338 30339 30340 30341 30342].sample

        almost_finished = {
          contact: contact,
          certification: ContactCandidacy.certifications.keys.sample,
          availability: ContactCandidacy.availabilities.keys.sample,
          experience: ContactCandidacy.experiences.keys.sample,
          transportation: ContactCandidacy.transportations.keys.sample,
          live_in: [true, false].sample,
          zipcode: zipcode,
          cpr_first_aid: [true, false].sample,
          inquiry: :skin_test
        }

        statuses = [just_started, midway, almost_finished]

        candidacy.assign_attributes(statuses.sample)
        candidacy.state = :in_progress
        candidacy.save
      end
    end

    trait :complete do
      after(:create) do |contact|
        contact.update(
          subscribed: [true, false].sample
        )

        candidacy = contact.contact_candidacy
        zipcode = %w[30319 30324 30327 30328 30329
                     30338 30339 30340 30341 30342].sample

        candidacy.assign_attributes(
          contact: contact,
          inquiry: nil,
          experience: ContactCandidacy.experiences.keys.sample,
          availability: ContactCandidacy.availabilities.keys.sample,
          transportation: ContactCandidacy.transportations.keys.sample,
          certification: ContactCandidacy.certifications.keys.sample,
          skin_test: [true, false].sample,
          live_in: [true, false].sample,
          zipcode: zipcode,
          cpr_first_aid: [true, false].sample,
          drivers_license: [true, false].sample,
          state: :complete
        )
        candidacy.save
      end
    end

    trait :pca do
      complete

      after(:create) do |contact|
        contact.contact_candidacy.update(certification: 'pca')
      end
    end

    trait :cna do
      complete

      after(:create) do |contact|
        contact.contact_candidacy.update(certification: 'cna')
      end
    end

    trait :am do
      complete

      after(:create) do |contact|
        contact.contact_candidacy.update(live_in: false, availability: 'hourly_am')
      end
    end

    trait :six_or_more do
      complete

      after(:create) do |contact|
        contact.contact_candidacy.update(experience: :six_or_more)
      end
    end

    trait :less_than_one do
      complete

      after(:create) do |contact|
        contact.contact_candidacy.update(experience: :less_than_one)
      end
    end

    trait :pm do
      complete

      after(:create) do |contact|
        contact.contact_candidacy.update(live_in: false, availability: 'hourly_pm')
      end
    end

    trait :hourly do
      complete

      after(:create) do |contact|
        contact.contact_candidacy.update(live_in: false, availability: 'hourly')
      end
    end

    trait :live_in do
      complete

      after(:create) do |contact|
        contact.contact_candidacy.update(live_in: true, availability: nil)
      end
    end
  end
end
