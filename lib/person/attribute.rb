class Person::Attribute
  def initialize(person)
    @person = person
  end

  def to_s
    label
  end

  attr_reader :person
end
