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
      account.inbox_conversations.find_or_create_by!(contact: contact)
    end
  end

  delegate :organization, to: :account
  delegate :contacts, to: :organization
end
