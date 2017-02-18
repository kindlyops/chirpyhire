class Candidacy < ApplicationRecord
  belongs_to :person
  belongs_to :subscriber, optional: true

  enum inquiry: {
    experience: 0, skin_test: 1, availability: 2, transportation: 3,
    zipcode: 4, cpr_first_aid: 5, certification: 6
  }

  def surveyed?
    subscriber.present?
  end
end
