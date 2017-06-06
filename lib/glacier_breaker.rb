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
      conversation = contact.open_conversation
      inbox_conversations(account).find_or_create_by(conversation: conversation)
    end
  end

  def inbox_conversations(account)
    account.inbox.inbox_conversations
  end

  delegate :organization, :inbox, to: :account
  delegate :contacts, to: :organization
end
