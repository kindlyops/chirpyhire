class ReadReceiptsCreator
  def initialize(message, organization)
    @message = message
    @organization = organization
  end

  def self.call(message, organization)
    new(message, organization).call
  end

  def call
    organization.conversations.contact(contact).find_each do |conversation|
      conversation.read_receipts.find_or_create_by!(message: message)
    end

    broadcast_sidebar
  end

  def contact
    organization.contacts.find_by(person: message.sender)
  end

  def broadcast_sidebar
    organization.accounts.find_each do |account|
      Broadcaster::Sidebar.new(account).broadcast
    end
  end

  attr_reader :message, :organization
end
