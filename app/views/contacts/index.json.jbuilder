json.rows do
  json.array! contacts do |contact|
    json.nickname contact.nickname
    json.created_at contact.created_at.to_json
    json.survey_progress do
      json.progress contact.survey_progress.to_json
      json.contact_id contact.id
    end

    json.last_reply_at do
      json.last_reply_at contact.last_reply_at.to_json
      json.contact_id contact.id
    end

    json.temperature do
      json.label contact.temperature.label
      json.icon_class contact.temperature.icon_class
      json.badge_class contact.temperature.badge_class
      json.contact_id contact.id
    end

    json.message do
      json.id contact.id
    end
  end
end
json.total @contacts.total_count
