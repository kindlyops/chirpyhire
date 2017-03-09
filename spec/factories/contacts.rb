FactoryGirl.define do
  factory :contact do
    person
    organization

    trait :with_incomplete_candidacy do
      after(:create) do |contact|
        contact.person.candidacy.update(
          contact: contact,
          experience: Candidacy.experiences.keys.sample,
          skin_test: [true, false].sample,
          availability: Candidacy.availabilities.keys.sample,
          transportation: Candidacy.transportations.keys.sample,
          zipcode: %w(30342 22902 30327 22903 90210).sample
        )
      end
    end

    trait :with_complete_candidacy do
      after(:create) do |contact|
        contact.update(
          subscribed: [true, false].sample,
          screened: [true, false].sample,
          candidate: true
        )

        contact.person.candidacy.update(
          contact: contact,
          inquiry: nil,
          experience: Candidacy.experiences.keys.sample,
          availability: Candidacy.availabilities.keys.sample,
          transportation: Candidacy.transportations.keys.sample,
          certification: Candidacy.certifications.keys.sample,
          skin_test: [true, false].sample,
          zipcode: %w(30342 22902 30327 22903 90210).sample,
          cpr_first_aid: [true, false].sample
        )
      end
    end
  end
end
