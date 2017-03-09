FactoryGirl.define do
  factory :contact do
    organization

    transient do
      phone_number nil
    end

    before(:create) do |contact, evaluator|
      person = if evaluator.phone_number
        create(:person, phone_number: evaluator.phone_number)
      else
        create(:person)
      end

      contact.person = person
    end

    trait :with_incomplete_candidacy do
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

    trait :with_complete_candidacy do
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
