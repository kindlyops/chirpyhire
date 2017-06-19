json.total_count candidates.object.total_count
json.current_page candidates.object.current_page
json.total_pages candidates.object.total_pages

json.candidates candidates do |candidate|
  json.id candidate.id
  json.nickname candidate.handle.label
  json.last_seen_at candidate.last_active_at.to_s
  json.last_seen_at_ago candidate.last_active_at.time_ago_format
  json.first_seen_at candidate.joined_at.to_s
  json.first_seen_at_ago candidate.joined_at.time_ago_format
  json.current_conversation_id candidate.current_conversation.id
  json.inbox_id candidate.current_conversation.inbox_id
  json.hero_pattern_classes candidate.hero_pattern_classes

  json.certification candidate.certification.to_s
  json.experience candidate.experience.to_s
  json.zipcode candidate.candidacy_zipcode.to_s
  json.availability candidate.availability.to_s
end
