class IceBreaker
  def self.call(contact)
    new(contact).call
  end

  def initialize(contact)
    @contact = contact
  end

  attr_reader :contact

  def call
    accounts.find_each do |account|
      broadcast(find_or_create_inbox_conversation(account))
    end

    open_conversation
  end

  def find_or_create_inbox_conversation(account)
    inbox_conversations(account)
      .find_or_create_by(conversation: open_conversation)
  end

  def inbox_conversations(account)
    account.inbox.inbox_conversations
  end

  def broadcast(inbox_conversation)
    Broadcaster::InboxConversation.broadcast(inbox_conversation)
  end

  def open_conversation
    @open_conversation ||= begin
      existing_open_conversation = fetch_existing_open_conversation
      return existing_open_conversation if existing_open_conversation.present?

      inbox_conversations = fetch_inbox_conversations
      contact.conversations.create!.tap do
        inbox_conversations.find_each(&method(:broadcast))
      end
    end
  end

  def fetch_inbox_conversations
    contact.inbox_conversations
  end

  def fetch_existing_open_conversation
    contact.existing_open_conversation
  end

  delegate :organization, to: :contact
  delegate :accounts, to: :organization
end
