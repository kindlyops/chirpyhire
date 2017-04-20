class Caregiver::SurveyProgress
  def initialize(contact)
    @contact = contact
  end

  def to_csv
    person.candidacy.progress
  end

  def search_label
    to_csv.round
  end

  def to_json
    return 3 unless person.candidacy.progress.positive?
    person.candidacy.progress.round
  end

  attr_reader :contact

  delegate :person, to: :contact
end
