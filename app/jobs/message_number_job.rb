class MessageNumberJob < ApplicationJob
  def perform(message)
    return if message.to.present? && message.from.present?
    contact = message.conversation.contact
    organization = contact.organization
    client = organization.send(:messaging_client).send(:client)

    external_message = client.messages.get(message.sid)

    message.update(
      from: external_message.from,
      to: external_message.to
    )
  end
end
