FactoryGirl.define do
  factory :contact do
    organization
    association :person, :with_candidacy

    transient do
      phone_number nil
    end

    after(:create) do |contact, evaluator|
      if evaluator.phone_number.present?
        contact.person.update(phone_number: evaluator.phone_number)
      end
    end

    trait :not_ready do
      after(:create) do |contact|
        candidacy = contact.person.candidacy

        just_started = {
          contact: contact,
          certification: Candidacy.certifications.keys.sample,
          inquiry: :availability
        }

        midway = {
          contact: contact,
          certification: Candidacy.certifications.keys.sample,
          availability: Candidacy.availabilities.keys.sample,
          experience: Candidacy.experiences.keys.sample,
          inquiry: :transportation
        }

        zipcode = %w(30319 30324 30327 30328 30329
                     30338 30339 30340 30341 30342).sample

        almost_finished = {
          contact: contact,
          certification: Candidacy.certifications.keys.sample,
          availability: Candidacy.availabilities.keys.sample,
          experience: Candidacy.experiences.keys.sample,
          transportation: Candidacy.transportations.keys.sample,
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

    trait :candidate do
      after(:create) do |contact|
        contact.update(
          subscribed: [true, false].sample,
          candidate: true
        )

        candidacy = contact.person.candidacy
        zipcode = %w(30319 30324 30327 30328 30329
                     30338 30339 30340 30341 30342).sample

        candidacy.assign_attributes(
          contact: contact,
          inquiry: nil,
          experience: Candidacy.experiences.keys.sample,
          availability: Candidacy.availabilities.keys.sample,
          transportation: Candidacy.transportations.keys.sample,
          certification: Candidacy.certifications.keys.sample,
          skin_test: [true, false].sample,
          zipcode: zipcode,
          cpr_first_aid: [true, false].sample,
          state: :complete
        )
        candidacy.save
      end
    end

    trait :pca do
      candidate

      after(:create) do |contact|
        contact.candidacy.update(certification: 'pca')
      end
    end

    trait :cna do
      candidate

      after(:create) do |contact|
        contact.candidacy.update(certification: 'cna')
      end
    end
  end
end
