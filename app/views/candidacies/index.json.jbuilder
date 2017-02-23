json.rows do
  json.array! candidacies do |candidacy|
    json.id candidacy.id

    json.contact do
      json.handle do
        json.label candidacy.handle.label
        json.icon_class candidacy.handle.icon_class
        json.button_class candidacy.handle.button_class
      end

      json.phone_number do
        json.label candidacy.phone_number.label
        json.icon_class candidacy.phone_number.icon_class
        json.button_class candidacy.phone_number.button_class
      end
    end

    json.zipcode do
      json.label candidacy.zipcode.label
      json.icon_class candidacy.zipcode.icon_class
      json.button_class candidacy.zipcode.button_class
    end

    json.availability do
      json.availability do
        json.label candidacy.availability.label
        json.icon_class candidacy.availability.icon_class
        json.button_class candidacy.availability.button_class
      end

      json.transportation do
        json.label candidacy.transportation.label
        json.icon_class candidacy.transportation.icon_class
        json.button_class candidacy.transportation.button_class
      end
    end

    json.experience do
      json.label candidacy.experience.label
      json.icon_class candidacy.experience.icon_class
      json.button_class candidacy.experience.button_class
    end

    json.qualifications do
      json.certification do
        json.label candidacy.certification.label
        json.icon_class candidacy.certification.icon_class
        json.button_class candidacy.certification.button_class
      end

      json.skin_test do
        json.label candidacy.skin_test.label
        json.icon_class candidacy.skin_test.icon_class
        json.button_class candidacy.skin_test.button_class
      end

      json.cpr_first_aid do
        json.label candidacy.cpr_first_aid.label
        json.icon_class candidacy.cpr_first_aid.icon_class
        json.button_class candidacy.cpr_first_aid.button_class
      end
    end

    json.message do
      json.contact_id candidacy.subscribed.id
      json.contact_handle candidacy.handle.label
    end

    json.status do
      json.subscribed do
        json.label candidacy.subscribed.label
        json.icon_class candidacy.subscribed.icon_class
        json.button_class candidacy.subscribed.button_class
      end

      json.status do
        json.label candidacy.status.label
        json.icon_class candidacy.status.icon_class
        json.button_class candidacy.status.button_class
      end
    end
  end
end
json.total @candidacies.total_count
