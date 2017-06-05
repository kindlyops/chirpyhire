json.body message.body
json.external_created_at message.external_created_at.iso8601
json.id message.id
json.sender_url message.sender.avatar && message.sender.avatar.url(:medium)
json.sender_id message.sender_id
json.sender_handle message.sender_handle
json.sender_hero_pattern_classes message.decorate.sender_hero_pattern_classes
