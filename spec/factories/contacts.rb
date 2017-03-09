FactoryGirl.define do
  factory :contact do
    organization
    person

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
          experience: Candidacy.experiences.keys.sample,
          inquiry: :skin_test
        }

        midway = {
          contact: contact,
          experience: Candidacy.experiences.keys.sample,
          skin_test: [true, false].sample,
          availability: Candidacy.availabilities.keys.sample,
          inquiry: :transportation
        }

        almost_finished = {
          contact: contact,
          experience: Candidacy.experiences.keys.sample,
          skin_test: [true, false].sample,
          availability: Candidacy.availabilities.keys.sample,
          transportation: Candidacy.transportations.keys.sample,
          zipcode: ZipCodes.db.keys.sample,
          inquiry: :cpr_first_aid
        }

        statuses = [just_started, midway, almost_finished]

        candidacy.assign_attributes(statuses.sample)
        candidacy.progress = candidacy.current_progress
        candidacy.save
      end
    end

    trait :candidate do
      after(:create) do |contact|
        contact.update(
          subscribed: [true, false].sample,
          screened: [true, false].sample,
          candidate: true
        )

        candidacy = contact.person.candidacy

        candidacy.assign_attributes(
          contact: contact,
          inquiry: nil,
          experience: Candidacy.experiences.keys.sample,
          availability: Candidacy.availabilities.keys.sample,
          transportation: Candidacy.transportations.keys.sample,
          certification: Candidacy.certifications.keys.sample,
          skin_test: [true, false].sample,
          zipcode: ZipCodes.db.keys.sample,
          cpr_first_aid: [true, false].sample
        )
        candidacy.progress = candidacy.current_progress
        candidacy.save
      end
    end
  end
end
