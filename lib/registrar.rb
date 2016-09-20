class Registrar
  def initialize(account)
    @account = account
  end

  def register
    return unless organization.persisted?

    Organization.transaction do
      create_templates
      create_survey
      create_questions
      create_rules
      create_dummy_candidate_and_features
      organization.create_subscription!(plan: Plan.first, state: 'trialing', trial_message_limit: Plan::TRIAL_MESSAGE_LIMIT)
      TwilioProvisionerJob.perform_later(organization)
      IntercomSyncerJob.perform_later(organization)
    end
  end

  private

  attr_reader :account, :bad_fit, :welcome, :thank_you, :survey

  def create_survey
    @survey = organization.create_survey(bad_fit: bad_fit, welcome: welcome, thank_you: thank_you)
  end

  def create_templates
    @bad_fit = organization.templates.create(name: 'Bad Fit', body: "Thank you very much for your interest. Unfortunately, we don't "\
      'have a good fit for you at this time. If anything changes we will let you know.')
    @welcome = organization.templates.create(name: 'Welcome', body: "Hello this is #{organization.name}. We're so glad you are interested in learning about opportunities here. We have a few questions to ask you via text message.")
    @thank_you = organization.templates.create(name: 'Thank You', body: 'Thanks for your interest!')
  end

  def create_questions
    address_question = questions.create!(priority: 1, label: 'Address', type: 'AddressQuestion', text: 'What is your street address and zipcode?')
    address_question.create_address_question_option(distance: 10, latitude: organization.latitude, longitude: organization.longitude)
    questions.create(priority: 2, label: 'Transportation', type: 'YesNoQuestion', text: 'Do you have reliable personal transportation?')
    questions.create!(priority: 3, label: 'Availability', type: 'ChoiceQuestion', text: 'What is your availability?',
                      choice_question_options_attributes: [
                        { text: 'Live-in', letter: 'a' }, { text: 'Hourly', letter: 'b' }, { text: 'Both', letter: 'c' }
                      ])
  end

  def create_rules
    rules.create!(trigger: 'subscribe', actionable: survey.create_actionable)
    rules.create!(trigger: 'answer', actionable: survey.actionable)
    rules.create!(trigger: 'screen', actionable: thank_you.create_actionable)
  end

  def create_dummy_candidate_and_features
    candidate = user.create_candidate(status: 'Qualified')

    candidate.candidate_features.create(label: 'Address', properties: {
                                          child_class: 'address',
                                          address: location.full_street_address,
                                          latitude: location.latitude,
                                          longitude: location.longitude,
                                          postal_code: location.postal_code,
                                          country: location.country,
                                          city: location.city
                                        })

    candidate.candidate_features.create(label: 'Availability', properties: {
                                          child_class: 'choice',
                                          choice_option: 'Hourly'
                                        })

    candidate.candidate_features.create(label: 'Transportation', properties: {
                                          child_class: 'yes_no',
                                          yes_no_option: 'Yes'
                                        })
  end

  def rules
    @rules ||= organization.rules
  end

  def questions
    @questions ||= survey.questions
  end

  def organization
    @organization ||= account.organization
  end

  def location
    @location ||= organization.location
  end

  def user
    @user ||= account.user
  end
end
