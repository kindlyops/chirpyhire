class Seeder
  def seed
    seed_account
    seed_complete_contacts
    seed_zipcodes_for_people
    seed_organization_metrics
  end

  private

  attr_reader :organization, :account, :team

  def seed_organization_metrics
    organization.update(
      screened_contacts_count: screened_count,
      reached_contacts_count: reached_count,
      starred_contacts_count: starred_count
    )
  end

  def starred_count
    (ENV.fetch('DEMO_SEED_AMOUNT').to_i * 5 / 8).floor
  end

  def screened_count
    (ENV.fetch('DEMO_SEED_AMOUNT').to_i * 7 / 8).floor
  end

  def reached_count
    (ENV.fetch('DEMO_SEED_AMOUNT').to_i * 6 / 8).floor
  end

  def seed_complete_contacts
    complete_contacts unless organization.contacts.complete.exists?
  end

  def seed_demo_contact
    FactoryGirl.create(
      :contact, :complete,
      contact_params
    ).tap do |contact|
      contact.person.update(
        nickname: ENV.fetch('DEMO_NICKNAME'),
        phone_number: ENV.fetch('DEMO_PHONE')
      )
    end
  end

  def contact_params
    {
      subscribed: true,
      organization: organization,
      team: team
    }
  end

  def complete_contacts
    seed_messages(seed_demo_contact)
    contacts = FactoryGirl.create_list(
      :contact, ENV.fetch('DEMO_SEED_AMOUNT').to_i, :complete,
      contact_params
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
      break if result.blank?
    end
  end

  def seed_question_and_answer(contact, category, question)
    seed_question(contact, question)
    seed_answer(contact, category, question)
  end

  def seed_start(contact)
    person = contact.person
    person.sent_messages.create!(
      body: 'Start', sid: SecureRandom.uuid,
      sent_at: DateTime.current,
      external_created_at: DateTime.current,
      direction: 'inbound',
      sender: Chirpy.person,
      conversation: contact.conversation
    )
    contact.conversation.touch(:last_message_created_at)
  end

  def seed_question(contact, question)
    body = question.body
    contact.person.received_messages.create!(
      body: body,
      sid: SecureRandom.uuid,
      sent_at: DateTime.current,
      external_created_at: DateTime.current,
      direction: 'outbound-api',
      sender: Chirpy.person,
      conversation: contact.conversation
    )
    contact.conversation.touch(:last_message_created_at)
  end

  def seed_thank_you(contact)
    return unless contact.complete?
    body = Notification::ThankYou.new(contact).body
    contact.person.received_messages.create!(
      body: body, sid: SecureRandom.uuid,
      sent_at: DateTime.current,
      external_created_at: DateTime.current,
      direction: 'outbound-api',
      sender: Chirpy.person,
      conversation: contact.conversation
    )
    contact.conversation.touch(:last_message_created_at)
  end

  def seed_answer(contact, category, question)
    person = contact.person
    choice = person.candidacy.send(category.to_sym)
    return if choice.nil?
    choice = choice.to_sym if choice.respond_to?(:to_sym)
    answer = "Answer::#{category.camelcase}".constantize.new(question)

    body = answer_body(answer, choice, category)
    create_answer(contact, body)
  end

  def answer_body(answer, choice, category)
    if category != 'zipcode'
      answer.question.choices.invert[answer.choice_map.invert[choice]]
    else
      %w[30319 30324 30327 30328 30329
         30338 30339 30340 30341 30342].sample
    end
  end

  def create_answer(contact, body)
    person = contact.person
    person.sent_messages.create!(
      body: body,
      sid: SecureRandom.uuid,
      sent_at: DateTime.current,
      external_created_at: DateTime.current,
      direction: 'inbound',
      sender: person,
      conversation: contact.conversation
    )
    contact.conversation.touch(:last_message_created_at)
  end

  def team_attributes
    { name: 'Atlanta', phone_number: ENV.fetch('DEMO_ORGANIZATION_PHONE') }
  end

  def team_params
    team_attributes.merge(location_attributes: location_attributes)
  end

  def full_street_address
    '2225 Spring Walk Court, Chamblee, GA 30341, United States of America'
  end

  def organization_attributes
    {
      name: ENV.fetch('DEMO_ORGANIZATION_NAME'),
      twilio_account_sid: ENV.fetch('DEMO_TWILIO_ACCOUNT_SID'),
      twilio_auth_token: ENV.fetch('DEMO_TWILIO_AUTH_TOKEN'),
      teams_attributes: {
        '0' => team_params
      }
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
    @account = Account.create(account_attributes)
    @organization = account.organization
    @team = organization.teams.first
    setup_account

    puts 'Created Account'
  end

  def account_attributes
    {
      password: ENV.fetch('DEMO_PASSWORD'),
      person_attributes: { name: ENV.fetch('DEMO_NAME') },
      email: ENV.fetch('DEMO_EMAIL'),
      super_admin: true,
      organization_attributes: organization_attributes
    }
  end

  def setup_account
    setup_organization
    team.accounts << account
    account.create_inbox
    team.update(recruiter: account)
  end

  def setup_organization
    organization.create_ideal_candidate!(
      zipcodes_attributes: [{ value: '30341' }]
    )
    organization.create_recruiting_ad(
      team: team, body: RecruitingAd.body(team)
    )
    organization.update(recruiter: account)
  end

  def seed_zipcodes_for_people
    zipcodes = %w[30319 30324 30327 30328 30329
                  30338 30339 30340 30341 30342]
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
