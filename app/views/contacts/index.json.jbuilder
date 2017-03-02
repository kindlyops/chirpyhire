json.rows do
  json.array! contacts do |contact|
    json.nickname contact.nickname
    json.first_activity_at contact.first_activity_at
    json.survey_progress contact.survey_progress
    json.last_activity_at contact.last_activity_at
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
