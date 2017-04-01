json.rows do
  json.array! candidates do |candidate|
    json.id candidate.id

    json.last_reply_at do
      json.last_reply_at candidate.last_reply_at.to_json
      json.contact_id candidate.id
    end
    json.created_at candidate.created_at.to_json

    json.person do
      json.id candidate.id
      
      json.handle do
        json.label candidate.handle.label
        json.icon_class candidate.handle.icon_class
      end

      json.phone_number do
        json.label candidate.phone_number.label
      end
    end

    json.message do
      json.id candidate.id
    end
  end
end
json.total @candidates.total_count
