json.rows do
  json.array! contacts do |contact|
    json.nickname contact.nickname
    json.created_at contact.created_at.to_json
    json.survey_progress contact.survey_progress.to_json
    json.last_activity_at contact.last_activity_at.to_json
    json.temperature do
      json.label contact.temperature.label
      json.icon_class contact.temperature.icon_class
      json.badge_class contact.temperature.badge_class
    end
    json.message do
      json.id contact.id
    end
  end
end
json.total @contacts.total_count
