json.array! @conversations do |conversation|
  message = conversation.messages.by_recency.last

  json.id conversation.id
  json.contact_id conversation.contact.id
  json.handle conversation.contact.handle
  json.timestamp message.conversation_day.label
  json.unread_count conversation.unread_count(current_inbox)
  json.summary message.summary
end
