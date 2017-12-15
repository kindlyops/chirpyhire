require 'active_support/concern'

module StageScopes
  extend ActiveSupport::Concern

  class_methods do
    def potential
      joins(:stage).merge(ContactStage.potential)
    end

    def screened
      joins(:stage).merge(ContactStage.screened)
    end

    def scheduled
      joins(:stage).merge(ContactStage.scheduled)
    end

    def unarchived
      joins(:stage).merge(ContactStage.archived)
    end

    def not_now
      joins(:stage).merge(ContactStage.not_now)
    end

    def hired
      joins(:stage).merge(ContactStage.hired)
    end
  end
end
