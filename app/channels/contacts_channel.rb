class ContactsChannel < ApplicationCable::Channel
  def subscribed
    reject if contact.blank?
    stream_for contact
  end

  delegate :contacts, to: :current_account

  private

  def contact
    @contact ||= authorize(contacts.find(params[:id]), :show?)
  end
end
