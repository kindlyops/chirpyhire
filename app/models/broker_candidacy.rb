class BrokerCandidacy < ApplicationRecord
  belongs_to :person
  belongs_to :broker_contact, optional: true

  enum state: {
    pending: 0, in_progress: 1, complete: 2
  }

  enum inquiry: {
    experience: 0, skin_test: 1, availability: 2, transportation: 3,
    zipcode: 4, cpr_first_aid: 5, certification: 6, live_in: 7
  }

  enum experience: {
    less_than_one: 0, one_to_five: 1, six_or_more: 2, no_experience: 3
  }

  enum availability: {
    hourly: 1, hourly_am: 3, hourly_pm: 4
  }

  enum transportation: {
    personal_transportation: 0, public_transportation: 1, no_transportation: 2
  }

  enum certification: {
    pca: 0, cna: 1, other_certification: 2, no_certification: 3
  }

  def self.finished_survey
    where(inquiry: nil).where.not(
      experience: nil,
      skin_test: nil,
      availability: nil,
      transportation: nil,
      zipcode: nil,
      cpr_first_aid: nil,
      certification: nil
    )
  end

  alias_attribute :location, :zipcode
end
