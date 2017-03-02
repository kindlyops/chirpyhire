class Contact::SurveyProgress
  def initialize(contact)
    @contact = contact
  end

  def to_f
    return 3.0 unless person.candidacy.progress.positive?
    person.candidacy.progress
  end

  attr_reader :contact

  delegate :person, to: :contact
end
