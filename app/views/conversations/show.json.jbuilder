json.id conversation.id

json.messages conversation.messages.by_recency do |message|
  json.sender_handle message.sender_handle
  json.sender_id message.sender_id
  json.body message.body
  json.sender_hero_pattern_classes message.decorate.sender_hero_pattern_classes
  json.external_created_at message.external_created_at.iso8601
  json.id message.id
end

json.contact do
  json.id conversation.contact_id
  json.handle conversation.contact_handle
  json.phone_number conversation.contact_phone_number
  json.hero_pattern_classes conversation.contact_hero_pattern_classes

  json.zipcode do
    json.label conversation.contact.candidacy_zipcode.label
    json.tooltip_label conversation.contact.candidacy_zipcode.tooltip_label
    json.icon_class conversation.contact.candidacy_zipcode.icon_class
    json.query conversation.contact.candidacy_zipcode.query
  end

  json.certification do
    json.label conversation.contact.certification.label
    json.tooltip_label conversation.contact.certification.tooltip_label
    json.icon_class conversation.contact.certification.icon_class
    json.query conversation.contact.certification.query
  end

  json.availability do
    json.label conversation.contact.availability.label
    json.tooltip_label conversation.contact.availability.tooltip_label
    json.icon_class conversation.contact.availability.icon_class
    json.query conversation.contact.availability.query
  end

  json.live_in do
    json.label conversation.contact.live_in.label
    json.tooltip_label conversation.contact.live_in.tooltip_label
    json.icon_class conversation.contact.live_in.icon_class
    json.query conversation.contact.live_in.query
  end

  json.experience do
    json.label conversation.contact.experience.label
    json.tooltip_label conversation.contact.experience.tooltip_label
    json.icon_class conversation.contact.experience.icon_class
    json.query conversation.contact.experience.query
  end

  json.transportation do
    json.label conversation.contact.transportation.label
    json.tooltip_label conversation.contact.transportation.tooltip_label
    json.icon_class conversation.contact.transportation.icon_class
    json.query conversation.contact.transportation.query
  end

  json.cpr_first_aid do
    json.label conversation.contact.cpr_first_aid.label
    json.tooltip_label conversation.contact.cpr_first_aid.tooltip_label
    json.icon_class conversation.contact.cpr_first_aid.icon_class
    json.query conversation.contact.cpr_first_aid.query
  end

  json.skin_test do
    json.label conversation.contact.skin_test.label
    json.tooltip_label conversation.contact.skin_test.tooltip_label
    json.icon_class conversation.contact.skin_test.icon_class
    json.query conversation.contact.skin_test.query
  end
end
