json.total_count candidates.object.total_count
json.current_page candidates.object.current_page
json.total_pages candidates.object.total_pages
json.contact_total_count current_organization.contacts.unarchived.count

json.candidates candidates do |candidate|
  json.id candidate.id
  json.name candidate.handle
  json.last_seen_at candidate.last_active_at.to_s
  json.last_seen_at_ago candidate.last_active_at.time_ago_format
  json.first_seen_at candidate.joined_at.to_s
  json.first_seen_at_ago candidate.joined_at.time_ago_format
  json.current_conversation_id candidate.current_conversation&.id
  json.inbox_id candidate.current_conversation&.inbox_id
  json.hero_pattern_classes candidate.hero_pattern_classes
  json.stage candidate.stage_name
  json.source candidate.source
end
