json.id contact.id
json.handle contact.handle.to_s
json.phone_number contact.phone_number.to_s
json.hero_pattern_classes contact.hero_pattern_classes
json.contact_stage_id contact.contact_stage_id
json.contact_stages contact.organization.contact_stages do |stage|
  json.id stage.id
  json.name stage.name
end

json.existing_open_conversation_id(
  contact.existing_open_conversation && contact.existing_open_conversation.id
)

json.zipcode do
  json.label contact.candidacy_zipcode.label
  json.icon_class contact.candidacy_zipcode.icon_class
end

json.tags contact.tags.order(:name) do |tag|
  json.id tag.id
  json.name tag.name
end
