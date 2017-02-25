# if Rails.env.development?
#   Seeder.new.seed
#   puts "Development specific seeding completed"
# end

# puts "Seed completed"

organization_id = Organization.second.id
50.times do |q|
people = []
  1_000.times do |i|
    person = Person.new(nickname: Faker::Name.name, phone_number: "+1#{Faker::Number.number(10)}")
    person.contacts.build(subscribed: [true, false].sample, screened: [true, false].sample, organization_id: organization_id)
    person.build_candidacy(
      inquiry: nil,
      experience: Candidacy.experiences.keys.sample,
      availability: Candidacy.availabilities.keys.sample,
      transportation: Candidacy.transportations.keys.sample,
      certification: Candidacy.certifications.keys.sample,
      skin_test: [true, false].sample,
      zipcode: %w(30342 22902 30327 22903 90210).sample,
      cpr_first_aid: [true, false].sample
    )
    people << person
  end
  Person.import people, recursive: true
end

organization_id = Organization.third.id
50.times do |q|
people = []
  1_000.times do |i|
    person = Person.new(nickname: Faker::Name.name, phone_number: "+1#{Faker::Number.number(10)}")
    person.contacts.build(subscribed: [true, false].sample, screened: [true, false].sample, organization_id: organization_id)
    person.build_candidacy(
      inquiry: nil,
      experience: Candidacy.experiences.keys.sample,
      availability: Candidacy.availabilities.keys.sample,
      transportation: Candidacy.transportations.keys.sample,
      certification: Candidacy.certifications.keys.sample,
      skin_test: [true, false].sample,
      zipcode: %w(30342 22902 30327 22903 90210).sample,
      cpr_first_aid: [true, false].sample
    )
    people << person
  end
  Person.import people, recursive: true
end

organization_id = Organization.fourth.id
50.times do |q|
people = []
  1_000.times do |i|
    person = Person.new(nickname: Faker::Name.name, phone_number: "+1#{Faker::Number.number(10)}")
    person.contacts.build(subscribed: [true, false].sample, screened: [true, false].sample, organization_id: organization_id)
    person.build_candidacy(
      inquiry: nil,
      experience: Candidacy.experiences.keys.sample,
      availability: Candidacy.availabilities.keys.sample,
      transportation: Candidacy.transportations.keys.sample,
      certification: Candidacy.certifications.keys.sample,
      skin_test: [true, false].sample,
      zipcode: %w(30342 22902 30327 22903 90210).sample,
      cpr_first_aid: [true, false].sample
    )
    people << person
  end
  Person.import people, recursive: true
end

