json.id conversation.id

json.messages(
  conversation.messages.by_recency,
  partial: 'messages/message', as: :message
)

json.contact(
  conversation.contact,
  partial: 'contacts/contact', as: :contact
)
