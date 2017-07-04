class Migrate::Bot
  def self.call(organization)
    new(organization).call
  end

  def initialize(organization)
    @organization ||= organization
  end

  attr_reader :organization
  delegate :teams, :contacts, to: :organization

  def call
    connect_teams_to_bot
    create_campaign_contacts_for_contacts
  end

  def create_campaign_contacts_for_contacts
    contacts.find_each do |contact|
      message = most_recent_inbound_message(contact)
      next if message.blank?
      phone_number = phone_number_for(message)
      next if phone_number.blank?
      state = state_for(contact)
      question = question_for(contact)
      create_or_update_campaign_contact(contact, phone_number, state, question)
      contact.taggings.find_or_create_by(tag: screened_tag) if contact.screened?
    end
  end

  def create_or_update_campaign_contact(contact, phone_number, state, question)
    existing = existing_campaign?(contact, campaign, phone_number)
    return create(contact, phone_number, state, question) unless existing
    update(contact, phone_number, state, question)
  end

  def existing_campaign?(contact, campaign, phone_number)
    contact
      .campaign_contacts
      .where(campaign: campaign, phone_number: phone_number)
      .exists?
  end

  def update(contact, phone_number, state, question)
    campaign_contact = contact
                       .campaign_contacts
                       .find_by(campaign: campaign, phone_number: phone_number)

    campaign_contact.update(
      state: state,
      question: question
    )
  end

  def create(contact, phone_number, state, question)
    contact.campaign_contacts.create(
      campaign: campaign,
      phone_number: phone_number,
      state: state,
      question: question
    )
  end

  def connect_teams_to_bot
    teams.find_each do |team|
      next if existing_bot_campaign?(team)
      campaign = fetch_campaign(team)

      bot.bot_campaigns.create(inbox: team.inbox, campaign: campaign)
    end
  end

  def fetch_campaign
    name = "#{bot.name} on call: #{team.name}"
    organization.campaigns.find_or_create_by(name: name)
  end

  def existing_bot_campaign?(team)
    bot.bot_campaigns.where(inbox: team.inbox).exists?
  end

  def most_recent_inbound_message(contact)
    contact.messages.by_recency.where(direction: 'inbound').first
  end

  def phone_number_for(message)
    organization.phone_numbers.find_by(phone_number: message.to)
  end

  def state_for(contact)
    return :exited if contact&.contact_candidacy&.complete?
    return :active if contact&.contact_candidacy&.in_progress?
    :pending
  end

  def question_for(contact)
    inquiry = contact.contact_candidacy.inquiry
    return if inquiry.nil?
    bot.questions[inquiries[inquiry.to_sym]]
  end

  def bot
    @bot ||= BotMaker::DefaultBot.call(organization)
  end

  def screened_tag
    @screened_tag ||= organization.tags.find_or_create_by(name: 'Screened')
  end

  def inquiries
    {
      certification: 0, availability: 1, live_in: 2, experience: 3,
      transportation: 4, drivers_license: 5, zipcode: 6, cpr_first_aid: 7,
      skin_test: 8
    }
  end
end
