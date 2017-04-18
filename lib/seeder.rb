class Seeder
  def seed
    seed_organization
    seed_account
    seed_not_ready_contacts
    seed_candidate_contacts
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
    seed_answer(person, category)
  end

  def seed_start(contact)
    person = contact.person
    person.sent_messages.create(
      body: 'Start', sid: SecureRandom.uuid,
      sent_at: DateTime.current,
      external_created_at: DateTime.current,
      direction: 'inbound',
      organization: organization
    )
  end

  def seed_question(person, question)
    body = question.body
    person.received_messages.create(
      body: body,
      sid: SecureRandom.uuid,
      sent_at: DateTime.current,
      external_created_at: DateTime.current,
      direction: 'outbound-api',
      organization: organization
    )
  end

  def seed_thank_you(contact)
    return unless contact.candidate?
    body = Notification::ThankYou.new(contact).body
    contact.person.received_messages.create(
      body: body, sid: SecureRandom.uuid,
      sent_at: DateTime.current,
      external_created_at: DateTime.current,
      direction: 'outbound-api',
      organization: organization
    )
  end

  def seed_answer(person, category)
    choice = person.candidacy.send(category.to_sym)
    return if choice.nil?
    choice = choice.to_sym if choice.respond_to?(:to_sym)
    answer = "Answer::#{category.camelcase}".constantize.new({})

    body = answer_body(answer, choice, category)
    create_answer(person, body)
  end

  def answer_body(answer, choice, category)
    if category != 'zipcode'
      answer.choice_map.invert[choice]
    else
      %w(30002 30030 30032 30033 30303 30305 30306 30307 30308 30309 30310
         30312 30315 30316 30317 30319 30319 30324 30327 30328 30329 30338
         30339 30340 30341 30342 30345 30363).sample
    end
  end

  def create_answer(person, body)
    person.sent_messages.create(
      body: body,
      sid: SecureRandom.uuid,
      sent_at: DateTime.current,
      external_created_at: DateTime.current,
      direction: 'inbound',
      organization: organization
    )
  end

  def seed_organization
    @organization = find_or_create_organization
    seed_location
    organization.create_ideal_candidate!(
      zipcodes_attributes: [{ value: '30341' }]
    )
    puts 'Created Organization'
  end

  def seed_location
    organization.location || organization.create_location(
      latitude: 33.912779, longitude: -84.2975454,
      full_street_address: full_street_address,
      city: 'Chamblee', state: 'GA', state_code: 'GA',
      postal_code: '30341', country: 'United States of America',
      country_code: 'us'
    )
  end

  def full_street_address
    '2225 Spring Walk Court, Chamblee, GA 30341, United States of America'
  end

  def find_or_create_organization
    Organization.find_or_create_by!(
      name: ENV.fetch('DEMO_ORGANIZATION_NAME'),
      twilio_account_sid: ENV.fetch('DEMO_TWILIO_ACCOUNT_SID'),
      twilio_auth_token: ENV.fetch('DEMO_TWILIO_AUTH_TOKEN'),
      phone_number: ENV.fetch('DEMO_ORGANIZATION_PHONE')
    )
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
end
