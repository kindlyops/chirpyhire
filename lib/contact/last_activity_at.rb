class Contact::LastActivityAt
  def initialize(contact)
    @contact = contact
  end

  attr_reader :contact

  def search_label
    to_json
  end

  def to_csv
    contact.last_activity_at
  end

  def to_json
    to_csv.strftime('%-m/%-d/%y %I:%M%P')
  end
end
