class NotesChannel < ApplicationCable::Channel
  def subscribed
    reject if contact.blank?
    stream_for contact
  end

  delegate :contacts, to: :current_organization

  private

  def contact
    @contact ||= begin
      authorize(contacts.find(params[:contact_id]), :show?)
    end
  end
end
