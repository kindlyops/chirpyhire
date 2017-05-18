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
      account.conversations.find_or_create_by!(contact: contact)
    end
  end

  delegate :team, to: :contact
  delegate :accounts, to: :team
end
