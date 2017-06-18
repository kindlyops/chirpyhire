message = conversation.recent_message

json.id conversation.id
json.inbox_id conversation.inbox_id
json.contact_id conversation.contact_id
json.handle conversation.contact.handle
json.timestamp conversation.last_message_created_at.label
json.last_message_created_at(
  conversation.last_message_created_at.iso_time
)
json.state conversation.state
json.reopenable conversation.reopenable?
json.summary(message.summary) if message.present?
