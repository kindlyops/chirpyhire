module Contact::Candidate::Searchable
  extend ActiveSupport::Concern

  included do
    pg_search_scope :search_candidates, against: :content,
                                        using: { tsearch: {
                                          negation: true,
                                          prefix: true,
                                          tsvector_column: :content_tsearch
                                        } }
    before_save :set_candidate_content, if: :candidate?

    def build_candidate_content
      <<~CONTENT.squish.chomp
        #{handle} #{phone_number_search_label} #{zipcode} \
#{availability_search_label} #{screened_search_label} \
#{experience_search_label} #{certification_search_label} \
#{skin_test_search_label} #{cpr_first_aid_search_label} \
#{subscribed_search_label} #{status_search_label}
      CONTENT
    end

    def set_candidate_content
      self.content = build_candidate_content
    end
  end
end
