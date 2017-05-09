class Person::CreatedAt
  def initialize(person)
    @person = person
  end

  attr_reader :person

  def to_json
    return unless person.created_at.present?
    person.created_at.strftime('%-m/%-d/%y %I:%M%P')
  end
end
