class ConversationsController < ApplicationController
  decorates_assigned :conversation

  def show
    @conversation = authorize fetch_conversation
  end

  private

  def fetch_conversation
    ContactWrapper.new(Contact.find(params[:contact_id]))
  end
end
