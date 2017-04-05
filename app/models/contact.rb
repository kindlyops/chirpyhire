class Contact < ApplicationRecord
  include Contact::Searchable
  belongs_to :person
  belongs_to :organization

  delegate :handle, :phone_number, :zipcode, :availability,
           :experience, :certification, :skin_test,
           :cpr_first_aid, :nickname, :candidacy, to: :person
  delegate :inquiry, to: :person, prefix: true

  before_create :set_last_reply_at

  def self.candidate
    where(candidate: true)
  end

  def self.filter(filter_params)
    includes(person: :candidacy)
      .where(people: { 'candidacies' => filter_params.to_h })
  end

  def self.not_ready
    where(candidate: false)
  end

  def self.active
    where(subscribed: true)
  end

  def messages
    person.messages.where(organization: organization)
  end

  def unsubscribe!
    update!(subscribed: false)
  end

  def ideal?
    person.ideal?(organization.ideal_candidate)
  end

  def promising?
    !ideal?
  end

  def set_last_reply_at
    self.last_reply_at = DateTime.current
  end
end
