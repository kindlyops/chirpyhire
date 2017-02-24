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

    def decorated_candidacy
      @decorated_candidacy ||= person.candidacy.decorate
    end

    %i(availability experience certification skin_test cpr_first_aid subscribed
    status screened).each do |method|
      define_method(method) do
        decorated_candidacy.send(method).label
      end
    end

    def availability_label
      decorated_candidacy.availability.label
    end

    def experience_label
      decorated_candidacy.experience.label
    end

    def certification_label
      decorated_candidacy.certification.label
    end

    def skin_test_label
      decorated_candidacy.skin_test.label
    end

    def cpr_first_aid_label
      decorated_candidacy.cpr_first_aid.label
    end

    def subscribed_label
      decorated_candidacy.subscribed.label
    end

    def status_label
      decorated_candidacy.status.label
    end

    def screened_label
      decorated_candidacy.screened.label
    end
  end
end
