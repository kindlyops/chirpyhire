class Migrator::AccountMigrator
  def initialize(contact_migrator, new_contact, account)
    @contact_migrator = contact_migrator
    @new_contact = new_contact
    @account = account
  end

  attr_reader :contact_migrator, :new_contact, :account
  delegate :contact, :update_sid, :create_new_message, to: :contact_migrator

  def migrate
    create_new_conversations(contact, new_contact, account)
    create_notes(contact, new_contact, account)
  end

  private

  def create_new_conversations(contact, new_contact, account)
    Rails.logger.info 'Begin Creating New Conversations'
    contact.conversations.where(account: account[:from]).each do |conversation|
      new_conversation = create_new_conversation(
        conversation, new_contact, account
      )

      create_outbound_account_messages(conversation, new_contact, account)
      create_read_receipts(conversation, new_conversation, new_contact)
    end
    Rails.logger.info 'Complete Creating New Conversations'
  end

  def create_new_conversation(conversation, new_contact, account)
    Rails.logger.info "Create new conversation for Conversation: #{conversation.id}"
    new_conversation = account[:to].conversations.create!(
      contact: new_contact,
      unread_count: conversation.unread_count,
      last_viewed_at: conversation.last_viewed_at,
      created_at: conversation.created_at,
      updated_at: conversation.updated_at
    )
    Rails.logger.info "Created new conversation: #{new_conversation.id} for Conversation: #{conversation.id}"
    new_conversation
  end

  def create_outbound_account_messages(conversation, new_contact, account)
    Rails.logger.info 'Begin Creating Outbound Account Messages'
    conversation.messages.where(sender: account[:from].person).each do |message|
      sid = update_sid(message)

      create_new_message(
        new_contact, message,
        sid: sid, sender: account[:to].person, recipient: message.recipient
      )
    end
    Rails.logger.info 'Complete Creating Outbound Account Messages'
  end

  def create_read_receipt(new_conversation, new_message, receipt)
    Rails.logger.info "Begin Creating Receipt for Receipt: #{receipt.id}"
    new_receipt = new_conversation.read_receipts.create!(
      message: new_message,
      read_at: receipt.read_at,
      created_at: receipt.created_at,
      updated_at: receipt.updated_at
    )
    Rails.logger.info "Created Receipt: #{new_receipt.id} for Receipt: #{receipt.id}"
  end

  def create_message_read_receipts(conversation, message, new_message, new_conversation)
    Rails.logger.info "Begin Creating Read Receipts for Conversation: #{new_conversation.id} and Message: #{new_message.id}"
    message.read_receipts.where(conversation: conversation).find_each do |receipt|
      create_read_receipt(new_conversation, new_message, receipt)
    end
    Rails.logger.info "Complete Creating Read Receipts for Conversation: #{new_conversation.id} and Message: #{new_message.id}"
  end

  def create_read_receipts(conversation, new_conversation, new_contact)
    Rails.logger.info 'Begin Creating Read Receipts'
    conversation.messages.where(recipient: nil).each do |message|
      sid = message.sid.match(/MIGRATED:(.*)/).captures.first
      new_message = new_contact.messages.find_by!(sid: sid)

      create_message_read_receipts(
        conversation, message, new_message, new_conversation
      )
    end
    Rails.logger.info 'Complete Creating Read Receipts'
  end

  def create_note(new_contact, account, note)
    Rails.logger.info "Begin Creating Note for Note: #{note.id}"
    new_note = new_contact.notes.create!(
      body: note.body,
      account: account[:to],
      deleted_at: note.deleted_at,
      created_at: note.created_at,
      updated_at: note.updated_at
    )
    Rails.logger.info "Created Receipt: #{new_note.id} for Receipt: #{note.id}"
  end

  def create_notes(contact, new_contact, account)
    Rails.logger.info 'Begin Creating Notes'
    contact.notes.where(account: account[:from]).each do |note|
      create_note(new_contact, account, note)
    end
    Rails.logger.info 'Complete Creating Notes'
  end
end
