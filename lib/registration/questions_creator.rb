class Registration::QuestionsCreator
  def initialize(survey)
    @survey = survey
  end

  def call
    create_address_question
    create_transportation_question
    create_availability_question
  end

  private

  attr_reader :survey
  delegate :questions, :organization, to: :survey

  def create_address_question
    address_question = questions.create!(
      priority: 1,
      label: 'Address',
      type: 'AddressQuestion',
      text: 'What is your street address and zipcode?'
    )
    create_address_question_option(address_question)
  end

  def create_address_question_option(address_question)
    address_question.create_address_question_option(
      distance: 10,
      latitude: organization.latitude,
      longitude: organization.longitude
    )
  end

  def create_availability_question
    questions.create!(
      priority: 3,
      label: 'Availability',
      type: 'ChoiceQuestion',
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
