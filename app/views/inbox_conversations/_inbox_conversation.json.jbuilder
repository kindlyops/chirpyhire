message = inbox_conversation.messages.by_recency.last

json.id inbox_conversation.id
json.inbox_id inbox_conversation.inbox_id
json.conversation_id inbox_conversation.conversation_id
json.contact_id inbox_conversation.contact.id
json.handle inbox_conversation.contact.handle
json.timestamp inbox_conversation.last_message_created_at.label
json.last_message_created_at(
  inbox_conversation.last_message_created_at.iso_time
)
json.unread_count inbox_conversation.unread_count
json.state inbox_conversation.conversation.state

json.summary(message.summary) if message.present?
