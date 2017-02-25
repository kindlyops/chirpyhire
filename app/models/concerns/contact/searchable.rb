module Contact::Searchable
  extend ActiveSupport::Concern

  included do
    include PgSearch
    pg_search_scope :search, against: :content,
    using: { tsearch: {
      negation: true,
      prefix: true,
      tsvector_column: 'tsvector_content_tsearch'
    } }
    before_save :set_content, if: :candidate?

    def build_content
      <<~CONTENT.squish.chomp
        #{handle} #{phone_number} #{zipcode} #{availability_search_label} \
#{experience_search_label} #{certification_search_label} \
#{skin_test_search_label} #{cpr_first_aid_search_label} \
#{subscribed_search_label} #{status_search_label} \
#{screened_search_label}
      CONTENT
    end

    def set_content
      self.content = build_content
    end

    %i(availability experience certification
       skin_test cpr_first_aid subscribed status screened).each do |method|
      define_method("#{method}_search_label") do
        contact_trait = "Contact::#{method.to_s.camelize}".constantize
        contact_trait.new(self).search_label
      end
    end
  end
end
