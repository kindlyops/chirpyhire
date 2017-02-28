class MessagesChannel < ApplicationCable::Channel
  def subscribed
    contact = Contact.find(params[:contact_id])
    stream_for contact
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
