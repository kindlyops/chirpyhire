class Broadcaster::Temperature
  def initialize(contact)
    @contact = contact
  end

  def broadcast
    TemperaturesChannel.broadcast_to(candidacy, render_temperature)
  end

  private

  attr_reader :contact
  delegate :candidacy, to: :contact

  def render_temperature
    ContactsController.render partial: 'contacts/temperature', locals: {
      contact: contact.decorate
    }
  end
end
