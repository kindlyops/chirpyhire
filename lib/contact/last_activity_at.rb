class Contact::LastActivityAt
  def initialize(contact)
    @contact = contact
  end

  attr_reader :contact

  def to_s
    person.candidacy.updated_at.strftime('%-m/%-d/%y %I:%M%P')
  end

  delegate :person, to: :contact
end
