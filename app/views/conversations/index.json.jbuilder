json.array! @conversations do |conversation|
  message = conversation.messages.by_recency.last

  json.id conversation.id
  json.contact_id conversation.contact.id
  json.handle conversation.contact.handle
  json.timestamp conversation.decorate.last_message_created_at.label
  json.unread_count conversation.unread_count(current_inbox)
  json.state conversation.state

  json.summary(message.summary) if message.present?
end
