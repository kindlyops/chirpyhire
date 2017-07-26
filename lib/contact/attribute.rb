class Contact::Attribute
  def initialize(contact)
    @contact = contact
  end

  def to_s
    label
  end

  attr_reader :contact
  delegate :person, to: :contact
end
