class Broadcaster::Contact
  def self.broadcast(contact)
    new(contact).broadcast
  end

  def initialize(contact)
    @contact = contact
  end

  def broadcast
    ContactsChannel.broadcast_to(conversation, contact_hash)
  end

  private

  attr_reader :contact

  delegate :conversation, to: :contact

  def contact_hash
    JSON.parse(contact_string)
  end

  def contact_string
    ContactsController.render partial: 'contacts/contact', locals: {
      contact: contact
    }
  end
end
