class Candidacy < ApplicationRecord
  paginates_per 10
  belongs_to :person
  belongs_to :contact, optional: true

  delegate :actively_subscribed_to?, :subscribed_to, :handle,
           :phone_number, :contacts, to: :person

  enum state: {
    pending: 0, in_progress: 1, complete: 2
  }

  enum inquiry: {
    experience: 0, skin_test: 1, availability: 2, transportation: 3,
    zipcode: 4, cpr_first_aid: 5, certification: 6
  }

  enum experience: {
    less_than_one: 0, one_to_five: 1, six_or_more: 2, no_experience: 3
  }

  enum availability: {
    live_in: 0, hourly: 1, open: 2, hourly_am: 3, hourly_pm: 4
  }

  enum transportation: {
    personal_transportation: 0, public_transportation: 1, no_transportation: 2
  }

  enum certification: {
    pca: 0, cna: 1, other_certification: 2, no_certification: 3, hha: 4
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

  def status_for(organization)
    return :ideal if ideal?(organization.ideal_candidate)
    :promising
  end

  def ideal?(ideal_candidate)
    complete? && ideal_candidate.zipcode?(zipcode) &&
      other_attributes_ideal?
  end

  def transportable?
    transportation.present? && transportation != 'no_transportation'
  end

  def experienced?
    experience.present? && experience != 'no_experience'
  end

  def certified?
    certification.present? && certification != 'no_certification'
  end

  def available?
    availability.present?
  end

  def locatable?
    zipcode.present?
  end
  alias_attribute :location, :zipcode

  private

  def other_attributes_ideal?
    transportable? && experienced? && certified? && skin_test && cpr_first_aid
  end
end
