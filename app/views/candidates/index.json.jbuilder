json.rows do
  json.array! candidates do |candidate|
    json.id candidate.id

    json.person do
      json.handle do
        json.label candidate.handle.label
        json.icon_class candidate.handle.icon_class
        json.button_class candidate.handle.button_class
      end

      json.phone_number do
        json.label candidate.phone_number.label
        json.icon_class candidate.phone_number.icon_class
        json.button_class candidate.phone_number.button_class
      end
    end

    json.zipcode do
      json.label candidate.zipcode.label
      json.icon_class candidate.zipcode.icon_class
      json.button_class candidate.zipcode.button_class
    end

    json.availability do
      json.availability do
        json.label candidate.availability.label
        json.icon_class candidate.availability.icon_class
        json.button_class candidate.availability.button_class
      end

      json.transportation do
        json.label candidate.transportation.label
        json.icon_class candidate.transportation.icon_class
        json.button_class candidate.transportation.button_class
      end
    end

    json.experience do
      json.label candidate.experience.label
      json.icon_class candidate.experience.icon_class
      json.button_class candidate.experience.button_class
    end

    json.qualifications do
      json.certification do
        json.label candidate.certification.label
        json.icon_class candidate.certification.icon_class
        json.button_class candidate.certification.button_class
      end

      json.skin_test do
        json.label candidate.skin_test.label
        json.icon_class candidate.skin_test.icon_class
        json.button_class candidate.skin_test.button_class
      end

      json.cpr_first_aid do
        json.label candidate.cpr_first_aid.label
        json.icon_class candidate.cpr_first_aid.icon_class
        json.button_class candidate.cpr_first_aid.button_class
      end
    end

    json.screened do
      json.candidate_id candidate.subscribed.id
      json.candidate_handle candidate.handle.label
      json.candidate_screened candidate.screened.value
    end

    json.status do
      json.subscribed do
        json.label candidate.subscribed.label
        json.icon_class candidate.subscribed.icon_class
        json.button_class candidate.subscribed.button_class
      end

      json.status do
        json.label candidate.status.label
        json.icon_class candidate.status.icon_class
        json.button_class candidate.status.button_class
      end
    end
  end
end
json.total @candidates.total_count
