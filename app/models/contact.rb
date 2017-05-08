class Contact < ApplicationRecord
  belongs_to :person
  belongs_to :organization
  has_many :conversations
  has_many :notes

  delegate :handle, :phone_number, :candidacy_zipcode, :availability,
           :experience, :certification, :skin_test, :avatar, :transportation,
           :cpr_first_aid, :nickname, :candidacy, to: :person
  delegate :inquiry, to: :person, prefix: true

  before_create :set_last_reply_at

  def self.recently_replied
    order(last_reply_at: :desc)
  end

  def self.incomplete
    includes(person: :candidacy)
      .where.not(people: { 'candidacies' => { state: :complete } })
  end

  def self.complete
    includes(person: :candidacy)
      .where(people: { 'candidacies' =>  { state: :complete } })
  end

  def complete?
    person.candidacy.complete?
  end

  def self.candidacy_filter(filter_params)
    return current_scope unless filter_params.present?

    includes(person: :candidacy)
      .where(people: { 'candidacies' => filter_params })
  end

  def self.zipcode_filter(filter_params)
    return current_scope unless filter_params.present?

    includes(person: :zipcode).where(people: { 'zipcodes' => filter_params })
  end

  def self.subscribed
    where(subscribed: true)
  end

  def self.unsubscribed
    where(subscribed: false)
  end

  def messages
    organization.messages.where(sender: person).or(received_messages)
  end

  def subscribe
    update(subscribed: true)
  end

  def unsubscribe
    update(subscribed: false)
  end

  private

  def set_last_reply_at
    self.last_reply_at = DateTime.current
  end

  def received_messages
    organization.messages.where(recipient: person)
  end
end
