json.array! candidates do |candidate|
  json.id candidate.id
  json.handle candidate.handle.label
  json.last_messaged_at candidate.last_active_at.to_s
  json.last_messaged_at_ago candidate.last_active_at.time_ago_format
  json.first_messaged_at candidate.joined_at.to_s
  json.first_messaged_at_ago candidate.joined_at.time_ago_format
  json.current_conversation_id candidate.current_conversation.id
end
