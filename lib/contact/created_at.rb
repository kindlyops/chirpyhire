class Contact::CreatedAt
  def initialize(contact)
    @contact = contact
  end

  attr_reader :contact

  def to_json
    return unless contact.created_at.present?
    contact.created_at.strftime('%-m/%-d/%y %I:%M%P')
  end
end
