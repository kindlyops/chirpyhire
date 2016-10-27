class Registration::QuestionsCreator
  def initialize(survey)
    @survey = survey
  end

  def call
    create_location_question
    create_transportation_question
    create_availability_question
  end

  private

  attr_reader :survey
  delegate :questions, :organization, to: :survey

  def create_location_question
    questions.create!(
      priority: 1,
      label: 'Zipcode',
      type: ZipcodeQuestion.name,
      text: 'What is your five-digit zipcode?',
      zipcode_question_options_attributes: [
        { text: organization.location.zipcode }
      ]
    )
  end

  def create_availability_question
    questions.create!(
      priority: 3,
      label: 'Availability',
      type: ChoiceQuestion.name,
      text: 'What is your availability?',
      choice_question_options_attributes: availability_options
    )
  end

  def availability_options
    [
      { text: 'Live-in', letter: 'a' },
      { text: 'Hourly', letter: 'b' },
      { text: 'Both', letter: 'c' }
    ]
  end

  def create_transportation_question
    questions.create(
      priority: 2,
      label: 'Transportation',
      type: 'YesNoQuestion',
      text: 'Do you have reliable personal transportation?'
    )
  end
end
