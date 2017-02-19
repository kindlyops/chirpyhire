class Candidacy < ApplicationRecord
  belongs_to :person
  belongs_to :subscriber, optional: true

  enum inquiry: {
    experience: 0, skin_test: 1, availability: 2, transportation: 3,
    zipcode: 4, cpr_first_aid: 5, certification: 6
  }

  enum experience: {
    less_than_one: 0, one_to_five: 1, six_or_more: 2, no_experience: 3
  }

  enum availability: {
    live_in: 0, full_time: 1, part_time: 2, flexible: 3
  }

  enum transportation: {
    personal_transportation: 0, public_transportation: 1, no_transportation: 2
  }

  enum certification: {
    pca: 0, cna: 1, other_certification: 2, no_certification: 3
  }

  def surveying?
    subscriber.present?
  end
end
