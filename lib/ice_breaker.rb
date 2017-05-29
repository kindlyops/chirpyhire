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
      inbox_conversation(account).update!(conversation: conversation(contact))
    end
  end

  def conversation
    @conversation ||= begin
      contact.conversations.first || contact.conversations.create!
    end
  end

  def inbox_conversation(account)
    account.inbox.inbox_conversations.find_or_create_by!(contact: contact)
  end

  delegate :organization, to: :contact
  delegate :accounts, to: :organization
end
