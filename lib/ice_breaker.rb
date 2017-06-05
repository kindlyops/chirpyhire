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
  end

  def find_or_create_inbox_conversation(account)
    inbox_conversations(account).find_or_create_by(conversation: conversation)
  end

  def inbox_conversations(account)
    account.inbox.inbox_conversations
  end

  def broadcast(inbox_conversation)
    Broadcaster::InboxConversation.broadcast(inbox_conversation)
  end

  delegate :organization, :conversation, to: :contact
  delegate :accounts, to: :organization
end
