class Migrator::ContactMigrator
  def initialize(team_migrator, contact)
    @team_migrator = team_migrator
    @contact = contact
  end

  attr_reader :team_migrator
  delegate :created_team, :organizations,
           :accounts, to: :team_migrator

  def migrate
    new_contact = create_new_contact(contact)
    create_chirpy_messages(contact, new_contact)
    create_inbound_messages(contact, new_contact)

    accounts.each do |account|
      Migrator::AccountMigrator.new(self, new_contact, account).migrate
    end
  end

  def create_new_message(new_contact, message, sid:, sender:, recipient:)
    Rails.logger.info "Creating New Message for Message: #{message.id}"
    params = message_attributes(message).merge(
      sid: sid,
      sender: sender,
      recipient: recipient
    )

    new_message = new_contact.messages.create!(params)
    Rails.logger.info "Created New Message: #{new_message.id} for Message: #{message.id}"
  end

  def update_sid(message)
    sid = message.sid
    updated_sid = "MIGRATED:#{sid}"
    Rails.logger.info "Updating Message: #{message.id} SID to #{updated_sid}"
    message.update!(sid: updated_sid)
    Rails.logger.info "Updated Message: #{message.id} SID to #{updated_sid}"
    sid
  end

  private

  def message_attributes(message)
    {
      body: message.body,
      direction: message.direction,
      sent_at: message.sent_at,
      external_created_at: message.external_created_at,
      organization: organizations[:to],
      created_at: message.created_at,
      updated_at: message.updated_at
    }
  end

  def create_new_contact(contact)
    Rails.logger.info "Begin creating New Contact for Contact: #{contact.id}"
    new_contact = created_team.contacts.create!(contact_attributes(contact))
    Rails.logger.info "New Contact created: #{new_contact.id}"
    new_contact
  end

  def contact_attributes(contact)
    {
      person: contact.person,
      organization: organizations[:to],
      subscribed: contact.subscribed,
      last_reply_at: contact.last_reply_at,
      starred: contact.starred,
      created_at: contact.created_at,
      updated_at: contact.updated_at
    }
  end

  def create_chirpy_messages(contact, new_contact)
    Rails.logger.info 'Begin Creating Chirpy Messages'
    contact.messages.where(sender: Chirpy.person).each do |message|
      sid = update_sid(message)

      create_new_message(
        new_contact, message,
        sid: sid, sender: Chirpy.person, recipient: message.recipient
      )
    end
    Rails.logger.info 'Complete Creating Chirpy Messages'
  end

  def create_inbound_messages(contact, new_contact)
    Rails.logger.info 'Begin Creating Inbound Messages'
    contact.messages.where(recipient: nil).each do |message|
      sid = update_sid(message)

      create_new_message(
        new_contact, message,
        sid: sid, sender: message.sender, recipient: nil
      )
    end
    Rails.logger.info 'Complete Creating Inbound Messages'
  end
end
