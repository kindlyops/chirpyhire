json.id contact.id
json.handle contact.handle.to_s
json.phone_number contact.phone_number.to_s
json.hero_pattern_classes contact.hero_pattern_classes
json.starred contact.starred
json.outcome contact.outcome
json.outcomes Contact.outcomes.keys

json.url contact.avatar && contact.avatar.url(:medium)
json.existing_open_conversation_id(
  contact.existing_open_conversation && contact.existing_open_conversation.id
)

json.zipcode do
  json.label contact.candidacy_zipcode.label
  json.tooltip_label contact.candidacy_zipcode.tooltip_label
  json.icon_class contact.candidacy_zipcode.icon_class
  json.query contact.candidacy_zipcode.query
end

json.tags contact.tags.order(:name) do |tag|
  json.id tag.id
  json.name tag.name
end
