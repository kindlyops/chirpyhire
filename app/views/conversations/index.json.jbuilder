json.next_page @conversations.next_page
json.conversations conversations do |conversation|
  message = conversation.recent_part&.message

  json.id conversation.id
  json.inbox_id conversation.inbox_id
  json.contact_id conversation.contact_id
  json.handle conversation.contact.handle
  json.timestamp conversation.last_conversation_part_created_at.label
  json.last_conversation_part_created_at(
    conversation.last_conversation_part_created_at.iso_time
  )
  json.unread_count conversation.unread_count
  json.state conversation.state
  json.reopenable conversation.reopenable?
  json.summary(message.summary) if message.present?
end
