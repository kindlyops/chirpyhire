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
      account.inbox_conversations.find_or_create_by!(
        inbox: account.inbox, contact: contact
      )
    end
  end

  delegate :organization, to: :contact
  delegate :accounts, to: :organization
end
