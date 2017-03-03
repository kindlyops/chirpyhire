class Broadcaster::LastReply
  def initialize(contact)
    @contact = contact
  end

  def broadcast
    LastRepliesChannel.broadcast_to(candidacy, render_last_reply)
  end

  private

  attr_reader :contact
  delegate :candidacy, to: :contact

  def render_last_reply
    ContactsController.render partial: 'contacts/last_reply', locals: {
      contact: contact.decorate
    }
  end
end
