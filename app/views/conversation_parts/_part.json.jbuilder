json.body part.body
json.external_created_at part.happened_at.iso8601
json.id part.id
json.sender_url part.sender.avatar && part.sender.avatar.url(:medium)
json.sender_id part.sender_id
json.sender_handle part.sender_handle
json.sender_hero_pattern_classes part.decorate.sender_hero_pattern_classes
json.direction part.direction
