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
      account.inbox.conversations << contact.conversation
    end
  end

  delegate :organization, :inbox, to: :account
  delegate :contacts, to: :organization
end
