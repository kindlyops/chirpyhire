class Broadcaster::Contact
  def self.broadcast(contact)
    new(contact).broadcast
  end

  def initialize(contact)
    @contact = contact
  end

  def broadcast
    ContactsChannel.broadcast_to(contact, contact_hash)
  end

  private

  attr_reader :contact

  def contact_hash
    JSON.parse(contact_string)
  end

  def contact_string
    CandidatesController.render partial: 'contacts/contact', locals: {
      contact: contact.decorate
    }
  end
end
