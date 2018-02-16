class Reminders::RemovesController < ApplicationController
  helper_method :conversation_path
  def show
    @reminder = authorize(contact.reminders.find(params[:reminder_id]))
  end

  private

  def contact
    @contact ||= authorize(Contact.find(params[:contact_id]), :show?)
  end

  def conversation_path
    inbox_conversation_path(conversation.inbox, conversation)
  end

  def conversation
    contact.current_conversation
  end
end
