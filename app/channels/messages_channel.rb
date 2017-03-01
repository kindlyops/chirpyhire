class MessagesChannel < ApplicationCable::Channel
  def subscribed
    reject unless contact.present?
    stream_for contact
  end

  delegate :contacts, to: :current_organization

  private

  def contact
    @contact ||= contacts.find(params[:contact_id])
  end
end
