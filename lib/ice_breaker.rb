class IceBreaker
  def self.call(contact)
    new(contact).call
  end

  def initialize(contact)
    @contact = contact
  end

  attr_reader :contact

  def call
    accounts.find_each(&method(:find_or_create_inbox_conversation))
    find_or_create_inbox_conversation(team)
    notifiable_inbox_conversations.find_each(&method(:broadcast))
    open_conversation
  end

  def find_or_create_inbox_conversation(inboxable)
    inbox_conversations(inboxable)
      .find_or_create_by(conversation: open_conversation)
  end

  def inbox_conversations(inboxable)
    inboxable.inbox.inbox_conversations
  end

  def notifiable_inbox_conversations
    contact.inbox_conversations.where(conversation: contact.conversations)
  end

  def broadcast(inbox_conversation)
    Broadcaster::InboxConversation.broadcast(inbox_conversation)
  end

  def open_conversation
    @open_conversation ||= begin
      contact.existing_open_conversation || contact.conversations.create!
    end
  end

  delegate :team, to: :contact
  delegate :accounts, to: :team
end
