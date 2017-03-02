class Contact::FirstActivityAt
  def initialize(contact)
    @contact = contact
  end

  attr_reader :contact

  def to_s
    return candidacy_created_at unless person.messages.present?
    person.messages.first_reply_at.strftime('%-m/%-d/%y %I:%M%P')
  end

  private

  def candidacy_created_at
    person.candidacy.created_at.strftime('%-m/%-d/%y %I:%M%P')
  end

  delegate :person, to: :contact
end
