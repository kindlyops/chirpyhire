class Candidacy < ApplicationRecord
  belongs_to :person
  belongs_to :subscriber, optional: true

  enum inquiry: {
    experience: 0, skin_test: 1, availability: 2, transportation: 3,
    zipcode: 4, cpr_first_aid: 5, certification: 6
  }

  enum experience: {
    less_than_one: 0, one_to_five: 1, six_or_more: 2, none: 3
  }

  enum skin_test: {
    yes: 0, no: 1
  }

  enum availability: {
    live_in: 0, full_time: 1, part_time: 2, flexible: 3
  }

  enum cpr_first_aid: {
    yes: 0, no: 1
  }

  enum transportation: {
    personal: 0, public: 1, none: 2
  }

  enum certification: {
    pca: 0, cna: 1, other: 2, none: 3
  }

  def surveying?
    subscriber.present?
  end
end
