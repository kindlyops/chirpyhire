class Contact::LastActivityAt
  def initialize(contact)
    @contact = contact
  end

  attr_reader :contact

  def to_datetime
    return candidacy_updated_at unless person.messages.present?
    person.messages.last_reply_at
  end

  def to_s
    return formatted_candidacy_updated_at unless person.messages.present?
    person.messages.last_reply_at.strftime('%-m/%-d/%y %I:%M%P')
  end

  private

  def formatted_candidacy_updated_at
    candidacy_updated_at.strftime('%-m/%-d/%y %I:%M%P')
  end

  def candidacy_updated_at
    person.candidacy.updated_at
  end

  delegate :person, to: :contact
end
