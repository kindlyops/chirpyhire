module RecruitingCounts
  extend ActiveSupport::Concern

  included do
    counter_culture %i[organization]
    counter_culture %i[organization],
                    column_name: proc { |model|
                      'reached_contacts_count' if model.reached?
                    },
                    column_names: {
                      ["reached='t'"] => 'reached_contacts_count'
                    }
    counter_culture %i[organization],
                    column_name: proc { |model|
                      'starred_contacts_count' if model.starred?
                    },
                    column_names: {
                      ["starred='t'"] => 'starred_contacts_count'
                    }
  end
end
