json.id contact.id
json.handle contact.handle.to_s
json.phone_number contact.phone_number.to_s
json.hero_pattern_classes contact.hero_pattern_classes

json.zipcode do
  json.label contact.candidacy_zipcode.label
  json.tooltip_label contact.candidacy_zipcode.tooltip_label
  json.icon_class contact.candidacy_zipcode.icon_class
  json.query contact.candidacy_zipcode.query
end

json.certification do
  json.label contact.certification.label
  json.tooltip_label contact.certification.tooltip_label
  json.icon_class contact.certification.icon_class
  json.query contact.certification.query
end

json.availability do
  json.label contact.availability.label
  json.tooltip_label contact.availability.tooltip_label
  json.icon_class contact.availability.icon_class
  json.query contact.availability.query
end

json.live_in do
  json.label contact.live_in.label
  json.tooltip_label contact.live_in.tooltip_label
  json.icon_class contact.live_in.icon_class
  json.query contact.live_in.query
end

json.experience do
  json.label contact.experience.label
  json.tooltip_label contact.experience.tooltip_label
  json.icon_class contact.experience.icon_class
  json.query contact.experience.query
end

json.transportation do
  json.label contact.transportation.label
  json.tooltip_label contact.transportation.tooltip_label
  json.icon_class contact.transportation.icon_class
  json.query contact.transportation.query
end

json.cpr_first_aid do
  json.label contact.cpr_first_aid.label
  json.tooltip_label contact.cpr_first_aid.tooltip_label
  json.icon_class contact.cpr_first_aid.icon_class
  json.query contact.cpr_first_aid.query
end

json.skin_test do
  json.label contact.skin_test.label
  json.tooltip_label contact.skin_test.tooltip_label
  json.icon_class contact.skin_test.icon_class
  json.query contact.skin_test.query
end
