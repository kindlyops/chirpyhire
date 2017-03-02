class Contact::LastActivityAt
  def initialize(contact)
    @contact = contact
  end

  attr_reader :contact

  def to_s
    contact.last_activity_at.strftime('%-m/%-d/%y %I:%M%P')
  end
end
