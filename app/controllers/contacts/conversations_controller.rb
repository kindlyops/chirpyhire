class Contacts::ConversationsController < ApplicationController
  def new
    return create_conversation_and_redirect if one_phone_number?

    @conversation = contact.conversations.build
  end

  def create
    @conversation = new_conversation
    @conversation.inbox = @conversation.phone_number.assignment_rule.inbox

    if @conversation.save
      redirect_to inbox_conversation_path(@conversation.inbox, @conversation)
    else
      render :new
    end
  end

  private

  def new_conversation
    authorize(contact.conversations.build(permitted_attributes(Conversation)))
  end

  def one_phone_number?
    organization.phone_numbers.count == 1
  end

  def create_conversation_and_redirect
    @conversation = IceBreaker.call(contact, phone_number)
    redirect_to inbox_conversation_path(@conversation.inbox, @conversation)
  end

  def phone_number
    organization.phone_numbers.first
  end

  delegate :organization, to: :contact

  def contact
    @contact ||= authorize(Contact.find(params[:contact_id]), :show?)
  end
end
