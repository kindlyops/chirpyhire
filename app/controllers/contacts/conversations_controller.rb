class Contacts::ConversationsController < ApplicationController
  def new
    @conversation = IceBreaker.call(contact, phone_number)
    redirect_to inbox_conversation_path(@conversation.inbox, @conversation)
  end

  private

  def phone_number
    organization.phone_numbers.first
  end

  delegate :organization, to: :contact

  def contact
    @contact ||= authorize(Contact.find(params[:contact_id]), :show?)
  end
end
