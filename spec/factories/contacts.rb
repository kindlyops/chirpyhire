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

    trait :incomplete do
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

        zipcode = %w(30002 30030 30032 30033 30303 30305 30306 30307 30308
                     30309 30310 30312 30315 30316 30317 30319 30319 30324 30327 30328
                     30329 30338 30339 30340 30341 30342 30345 30363).sample

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
        candidacy.save
      end
    end

    trait :complete do
      after(:create) do |contact|
        contact.update(
          subscribed: [true, false].sample
        )

        candidacy = contact.person.candidacy
        zipcode = %w(30002 30030 30032 30033 30303 30305 30306 30307 30308
                     30309 30310 30312 30315 30316 30317 30319 30319 30324 30327 30328
                     30329 30338 30339 30340 30341 30342 30345 30363).sample

        candidacy.assign_attributes(
          contact: contact,
          inquiry: nil,
          experience: Candidacy.experiences.keys.sample,
          availability: Candidacy.availabilities.keys.sample,
          transportation: Candidacy.transportations.keys.sample,
          certification: Candidacy.certifications.keys.sample,
          skin_test: [true, false].sample,
          zipcode: zipcode,
          cpr_first_aid: [true, false].sample
        )
        candidacy.save
      end
    end

    trait :pca do
      complete

      after(:create) do |contact|
        contact.candidacy.update(certification: 'pca')
      end
    end

    trait :cna do
      complete

      after(:create) do |contact|
        contact.candidacy.update(certification: 'cna')
      end
    end
  end
end
