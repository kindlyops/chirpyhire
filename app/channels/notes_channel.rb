class NotesChannel < ApplicationCable::Channel
  def subscribed
    reject if contact.blank?
    stream_for contact
  end

  delegate :contacts, to: :current_account

  private

  def contact
    @contact ||= contacts.find(params[:contact_id])
  end
end