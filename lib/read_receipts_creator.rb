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

    Broadcaster::Sidebar.new(organization).broadcast
  end

  def contact
    organization.contacts.find_by(person: message.sender)
  end

  attr_reader :message, :organization
end
