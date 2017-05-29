class Contact < ApplicationRecord
  belongs_to :person
  belongs_to :team
  belongs_to :organization, optional: true
  include RecruitingCounts

  def organization
    super || team.organization
  end

  has_many :inbox_conversations
  has_many :conversations

  has_many :notes

  delegate :handle, :phone_number, :candidacy_zipcode, :availability,
           :experience, :certification, :skin_test, :avatar, :transportation,
           :cpr_first_aid, :nickname, :candidacy, :live_in, to: :person
  delegate :inquiry, to: :person, prefix: true
  delegate :phone_number, to: :team, prefix: true

  before_create :set_last_reply_at

  def conversation
    conversations.first || conversations.create!
  end

  def self.recently_replied
    order('last_reply_at DESC NULLS LAST')
  end

  def self.max_notes_count
    joins(:notes)
      .group('notes.contact_id, contacts.last_reply_at')
      .count.values.max
  end

  def self.candidacy_filter(filter_clause)
    return current_scope if filter_clause.blank?

    joins(person: :candidacy).where(filter_clause)
  end

  def self.starred_filter(filter_params)
    return current_scope if filter_params.blank?

    where(filter_params)
  end

  def self.zipcode_filter(filter_params)
    return current_scope if filter_params.blank?

    filters = filter_params.map do |k, v|
      sanitize_sql_array(["lower(\"zipcodes\".\"#{k}\") = ?", v.downcase])
    end.join(' AND ')

    joins(person: :zipcode).where(filters)
  end

  def self.incomplete
    includes(person: :candidacy)
      .where.not(people: { 'candidacies' => { state: :complete } })
  end

  def self.complete
    includes(person: :candidacy)
      .where(people: { 'candidacies' => { state: :complete } })
  end

  def complete?
    person.candidacy.complete?
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

  def received_messages
    organization.messages.where(recipient: person)
  end

  private

  def set_last_reply_at
    self.last_reply_at = DateTime.current
  end
end
