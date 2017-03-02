module Contact::Searchable
  extend ActiveSupport::Concern

  included do
    include PgSearch
    include Contact::Candidate::Searchable
    include Contact::NotReady::Searchable

    %i(availability experience certification phone_number
       skin_test cpr_first_aid subscribed status screened
       created_at survey_progress last_reply_at temperature).each do |method|
      define_method("#{method}_search_label") do
        contact_trait = "Contact::#{method.to_s.camelize}".constantize
        contact_trait.new(self).search_label
      end
    end
  end
end
