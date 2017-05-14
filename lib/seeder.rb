class Seeder
  def seed
    seed_organization
    seed_account
    seed_not_ready_contacts
    seed_candidate_contacts
    seed_zipcodes_for_people
  end

  private

  attr_reader :organization

  def seed_not_ready_contacts
    not_ready_contacts unless organization.contacts.not_ready.exists?
  end

  def seed_candidate_contacts
    candidate_contacts unless organization.contacts.candidate.exists?
  end

  def not_ready_contacts
    seed_demo_contact
    contacts = FactoryGirl.create_list(
      :contact, ENV.fetch('DEMO_SEED_AMOUNT').to_i, :not_ready,
      organization: organization
    )
    contacts.each(&method(:seed_messages))
  end

  def seed_demo_contact
    person = seed_demo_person

    contact = FactoryGirl.create(
      :contact,
      :not_ready,
      person: person,
      subscribed: true,
      organization: organization,
      phone_number: ENV.fetch('DEMO_PHONE')
    )
    seed_messages(contact)
  end

  def seed_demo_person
    FactoryGirl.create(:person,
                       :with_candidacy,
                       nickname: ENV.fetch('DEMO_NICKNAME'))
  end

  def candidate_contacts
    contacts = FactoryGirl.create_list(
      :contact, ENV.fetch('DEMO_SEED_AMOUNT').to_i, :candidate,
      organization: organization
    )
    contacts.each(&method(:seed_messages))
  end

  def seed_messages(contact)
    IceBreaker.call(contact)
    seed_start(contact)
    seed_thank_you(contact) if seed_questions(contact)
  end

  def seed_questions(contact)
    Survey.new(contact.person.candidacy).questions.each do |category, question|
      result = seed_question_and_answer(contact, category, question)
      break unless result.present?
    end
  end

  def seed_question_and_answer(contact, category, question)
    person = contact.person
    seed_question(person, question)
    seed_answer(person, category, question)
  end

  def seed_start(contact)
    person = contact.person
    person.sent_messages.create!(
      body: 'Start', sid: SecureRandom.uuid,
      sent_at: DateTime.current,
      external_created_at: DateTime.current,
      direction: 'inbound',
      sender: Chirpy.person,
      organization: organization
    )
  end

  def seed_question(person, question)
    body = question.body
    person.received_messages.create!(
      body: body,
      sid: SecureRandom.uuid,
      sent_at: DateTime.current,
      external_created_at: DateTime.current,
      direction: 'outbound-api',
      sender: Chirpy.person,
      organization: organization
    )
  end

  def seed_thank_you(contact)
    return unless contact.candidate?
    body = Notification::ThankYou.new(contact).body
    contact.person.received_messages.create!(
      body: body, sid: SecureRandom.uuid,
      sent_at: DateTime.current,
      external_created_at: DateTime.current,
      direction: 'outbound-api',
      sender: Chirpy.person,
      organization: organization
    )
  end

  def seed_answer(person, category, question)
    choice = person.candidacy.send(category.to_sym)
    return if choice.nil?
    choice = choice.to_sym if choice.respond_to?(:to_sym)
    answer = "Answer::#{category.camelcase}".constantize.new(question)

    body = answer_body(answer, choice, category)
    create_answer(person, body)
  end

  def answer_body(answer, choice, category)
    if category != 'zipcode'
      answer.question.choices.invert[answer.choice_map.invert[choice]]
    else
      %w(30319 30324 30327 30328 30329
         30338 30339 30340 30341 30342).sample
    end
  end

  def create_answer(person, body)
    person.sent_messages.create!(
      body: body,
      sid: SecureRandom.uuid,
      sent_at: DateTime.current,
      external_created_at: DateTime.current,
      direction: 'inbound',
      sender: person,
      organization: organization
    )
  end

  def seed_organization
    @organization = find_or_create_organization
    organization.create_ideal_candidate!(
      zipcodes_attributes: [{ value: '30341' }]
    )
    organization.create_recruiting_ad(body: RecruitingAd.body(organization))
    puts 'Created Organization, Ideal Candidate, and Recruiting Ad'
  end

  def full_street_address
    '2225 Spring Walk Court, Chamblee, GA 30341, United States of America'
  end

  def find_or_create_organization
    found_organization = Organization.find_by(organization_attributes)

    found_organization || create_organization
  end

  def create_organization
    attributes = organization_attributes.merge(
      location_attributes: location_attributes
    )

    Organization.create!(attributes)
  end

  def organization_attributes
    {
      name: ENV.fetch('DEMO_ORGANIZATION_NAME'),
      twilio_account_sid: ENV.fetch('DEMO_TWILIO_ACCOUNT_SID'),
      twilio_auth_token: ENV.fetch('DEMO_TWILIO_AUTH_TOKEN'),
      phone_number: ENV.fetch('DEMO_ORGANIZATION_PHONE')
    }
  end

  def location_attributes
    { latitude: 33.912779, longitude: -84.2975454,
      full_street_address: full_street_address,
      city: 'Chamblee', state: 'Georgia', state_code: 'GA',
      postal_code: '30341', country: 'United States of America',
      country_code: 'us' }
  end

  def seed_account
    unless organization.accounts.present?
      account = organization.accounts.create!(
        password: ENV.fetch('DEMO_PASSWORD'),
        person_attributes: { name: ENV.fetch('DEMO_NAME') },
        email: ENV.fetch('DEMO_EMAIL'),
        super_admin: true
      )
      organization.update(recruiter: account)
    end

    puts 'Created Account'
  end

  def seed_zipcodes_for_people
    zipcodes = %w(30319 30324 30327 30328 30329
                  30338 30339 30340 30341 30342)
    zipcodes.each do |zipcode|
      FactoryGirl.create(:zipcode, zipcode.to_sym)
    end
    Person.find_each do |p|
      next if p.candidacy.blank? || p.candidacy.zipcode.blank?
      ZipcodeFetcher.call(p, p.candidacy.zipcode)
    end

    puts 'Zipcodes Added'
  end
end
