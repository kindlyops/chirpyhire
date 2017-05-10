FactoryGirl.define do
  factory :broker_contact do
    association :person, :with_broker_candidacy
    broker

    trait :broker_candidate do
      after(:create) do |contact|
        contact.update(
          subscribed: [true, false].sample
        )

        candidacy = contact.person.broker_candidacy
        zipcode = %w(30319 30324 30327 30328 30329
                     30338 30339 30340 30341 30342).sample

        candidacy.assign_attributes(
          broker_contact: contact,
          inquiry: nil,
          experience: BrokerCandidacy.experiences.keys.sample,
          availability: BrokerCandidacy.availabilities.keys.sample,
          transportation: BrokerCandidacy.transportations.keys.sample,
          certification: BrokerCandidacy.certifications.keys.sample,
          skin_test: [true, false].sample,
          zipcode: zipcode,
          cpr_first_aid: [true, false].sample,
          state: :complete
        )
        candidacy.save
      end
    end
  end
end
