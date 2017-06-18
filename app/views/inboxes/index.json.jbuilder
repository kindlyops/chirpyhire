json.array! inboxes do |inbox|
  json.id inbox.id
  json.name inbox.name
  json.url inbox.url
  json.hero_pattern_classes inbox.hero_pattern_classes
end
