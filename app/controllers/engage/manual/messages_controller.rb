class Engage::Manual::MessagesController < ApplicationController
  def create
    @new_manual_message = authorize new_manual_message

    run_and_send_notification if @new_manual_message.save
    head :ok
  end

  private

  def new_manual_message
    current_account.manual_messages.build(permitted_attributes(ManualMessage))
  end

  def run_and_send_notification
    Broadcaster::Notification.broadcast(current_account, notification)


    ManualMessageJob.perform_later(@new_manual_message)
  end

  def notification
    {
      message: 'Your message is now sending',
      key: SecureRandom.uuid
    }
  end
end

# ContactsManualMessage
  # -> contact, message_id, manual_message_id

# Create Manual Message
# Lookup all the candidates in the audience
# For each candidate in the audience
# Send the message
# Tie the message to the manual message
# Lookup candidate through message

# When the candidate replies, and the last message has a manual message
# Tie the new message to the manual message as a reply
