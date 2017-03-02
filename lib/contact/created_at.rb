class Contact::CreatedAt
  def initialize(contact)
    @contact = contact
  end

  attr_reader :contact

  def to_csv
    contact.created_at
  end

  def to_json
    to_csv.strftime('%-m/%-d/%y %I:%M%P')
  end
end
