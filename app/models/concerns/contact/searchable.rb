module Contact::Searchable
  extend ActiveSupport::Concern

  included do
    search_attributes = lambda do |contact|
      { organization_id: contact.organization_id }
    end

    multisearchable against: [:handle, :phone_number, :zipcode,
                              :availability_label, :experience_label,
                              :certification_label, :skin_test_label,
                              :cpr_first_aid_label, :subscribed_label,
                              :status_label, :screened_label],
                    additional_attributes: search_attributes,
                    if: :complete?

    %i(availability experience certification
       skin_test cpr_first_aid).each do |method|
      define_method("#{method}_label") do
        candidacy_trait = "Candidacy::#{method.to_s.camelize}".constantize
        candidacy_trait.new(person.candidacy).label
      end
    end

    %i(subscribed status screened).each do |method|
      define_method("#{method}_label") do
        candidacy_trait = "Candidacy::#{method.to_s.camelize}".constantize
        candidacy_trait.new(person.candidacy, organization).label
      end
    end
  end
end
