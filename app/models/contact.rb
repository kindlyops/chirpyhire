class Contact < ApplicationRecord
  belongs_to :person
  belongs_to :organization
  has_many :conversations
  has_many :notes

  delegate :handle, :phone_number, :candidacy_zipcode, :availability,
           :experience, :certification, :skin_test, :avatar, :transportation,
           :cpr_first_aid, :nickname, :candidacy, :live_in, to: :person
  delegate :inquiry, to: :person, prefix: true

  before_create :set_last_reply_at

  def self.recently_replied
    order(last_reply_at: :desc)
  end

  def self.candidate
    where(candidate: true)
  end

  def self.candidacy_filter(filter_clause)
    return current_scope unless filter_clause.present?

    joins(person: :candidacy).where(filter_clause)
  end

  def self.starred_filter(filter_params)
    return current_scope unless filter_params.present?

    where(filter_params)
  end

  def self.zipcode_filter(filter_params)
    return current_scope unless filter_params.present?

    filters = filter_params.map do |k, v|
      sanitize_sql_array(["lower(\"zipcodes\".\"#{k}\") = ?", v.downcase])
    end.join(' AND ')

    joins(person: :zipcode).where(filters)
  end

  def self.not_ready
    where(candidate: false)
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

  def ideal?
    person.ideal?(organization.ideal_candidate)
  end

  def promising?
    !ideal?
  end

  private

  def set_last_reply_at
    self.last_reply_at = DateTime.current
  end

  def received_messages
    organization.messages.where(recipient: person)
  end
end
