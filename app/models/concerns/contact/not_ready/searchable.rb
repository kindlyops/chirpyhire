module Contact::NotReady::Searchable
  extend ActiveSupport::Concern

  included do
    pg_search_scope :search_not_ready, against: :not_ready_content,
                                       using: { tsearch: {
                                         negation: true,
                                         prefix: true,
                                         tsvector_column:
                                         :not_ready_content_tsearch
                                       } }
    before_save :set_not_ready_content, unless: :candidate?

    def build_not_ready_content
      <<~CONTENT.squish.chomp
        #{nickname} #{created_at_search_label} #{survey_progress_search_label} \
#{last_activity_at_search_label} #{temperature_search_label}
      CONTENT
    end

    def set_not_ready_content
      self.not_ready_content = build_not_ready_content
    end
  end
end
