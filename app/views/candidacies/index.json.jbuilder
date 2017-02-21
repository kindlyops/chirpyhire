json.array! @candidacies do |candidacy|
  json.contact_information do
    json.handle candidacy.handle
    json.phone_number candidacy.phone_number.phony_formatted
  end

  json.location candidacy.zipcode

  json.availability do
    json.schedule candidacy.availability
    json.transportation candidacy.transportation
  end

  json.experience candidacy.experience

  json.qualifications do
    json.certification candidacy.certification
    json.skin_test candidacy.skin_test
    json.cpr_first_aid candidacy.cpr_first_aid
  end

  json.subscribed candidacy.subscribed_to?(current_organization)
  json.status candidacy.status_for(current_organization)
end
