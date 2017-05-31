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
      inbox_conversations(account).find_or_create_by(conversation: conversation)
    end
  end

  def inbox_conversations(account)
    account.inbox.inbox_conversations
  end

  delegate :organization, :conversation, to: :contact
  delegate :accounts, to: :organization
end
