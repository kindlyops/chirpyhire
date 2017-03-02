class Candidacy < ApplicationRecord
  paginates_per 10
  belongs_to :person
  belongs_to :contact, optional: true
  after_save :set_contacts_content
  before_save :set_progress

  delegate :actively_subscribed_to?, :subscribed_to, :handle,
           :phone_number, :contacts, to: :person

  validates :progress, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100
  }

  enum inquiry: {
    experience: 0, skin_test: 1, availability: 2, transportation: 3,
    zipcode: 4, cpr_first_aid: 5, certification: 6
  }

  enum experience: {
    less_than_one: 0, one_to_five: 1, six_or_more: 2, no_experience: 3
  }

  enum availability: {
    live_in: 0, hourly: 1, both: 2, no_availability: 3
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

  def surveying?
    contact.present?
  end

  def status_for(organization)
    return :ideal if ideal?(organization.ideal_candidate)
    :promising
  end

  def screened_at(organization)
    return true if subscribed_to(organization).screened?
    false
  end

  def ideal?(ideal_candidate)
    complete? && ideal_candidate.zipcode?(zipcode) &&
      other_attributes_ideal?
  end

  def complete?
    surveying? && attributes_present?
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

  def build_progress
    progressable_attributes.count { |a| !a.nil? } /
      progressable_attributes.count.to_f * 100.0
  end

  private

  def progressable_attributes
    [experience, skin_test, availability,
     transportation, zipcode, cpr_first_aid,
     certification]
  end

  def other_attributes_ideal?
    transportable? && experienced? && certified? && skin_test && cpr_first_aid
  end

  def attributes_present?
    enum_attributes_present? && boolean_attributes_present?
  end

  def enum_attributes_present?
    experience.present? && availability.present? && transportation.present? &&
      zipcode.present? && certification.present?
  end

  def boolean_attributes_present?
    !cpr_first_aid.nil? && !skin_test.nil?
  end

  def set_contacts_content
    contacts.candidate.find_each(&:save)
  end

  def set_progress
    self.progress = build_progress
  end
end
