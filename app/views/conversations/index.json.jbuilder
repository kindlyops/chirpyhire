json.array! @conversations do |conversation|
  message = conversation.messages.by_recency.first

  json.id conversation.id
  json.contact_id conversation.contact.id
  json.handle conversation.contact.handle
  json.timestamp message.conversation_day.label
  json.unread_count conversation.unread_count
  json.summary message.summary
end

