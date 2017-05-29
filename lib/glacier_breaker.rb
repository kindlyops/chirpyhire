class GlacierBreaker
  def self.call(account)
    new(account).call
  end

  def initialize(account)
    @account = account
  end

  attr_reader :account

  def call
    contacts.find_each do |contact|
      inbox_conversation(contact).update!(conversation: conversation(contact))
    end
  end

  def conversation(contact)
    contact.conversations.first || contact.conversations.create!
  end

  def inbox_conversation(contact)
    inbox.inbox_conversations.find_or_create_by!(contact: contact)
  end

  delegate :organization, :inbox, to: :account
  delegate :contacts, to: :organization
end
