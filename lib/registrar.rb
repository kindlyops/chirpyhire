# frozen_string_literal: true
class Registrar
  def initialize(account)
    @account = account
  end

  def register
    return unless organization.persisted?

    Organization.transaction do
      setup_organization
      TwilioProvisionerJob.perform_later(organization)
      IntercomSyncerJob.perform_later(organization)
    end
  end

  private

  attr_reader :account, :bad_fit, :welcome, :thank_you, :survey

  def setup_organization
    create_templates
    create_survey
    create_questions
    create_rules
    create_dummy_candidate_and_features
    create_subscription
  end

  def create_subscription
    organization.create_subscription!(
      plan: Plan.first,
      state: 'trialing',
      trial_message_limit: Plan::TRIAL_MESSAGE_LIMIT
    )
  end

  def create_survey
    @survey = organization.create_survey(
      bad_fit: bad_fit,
      welcome: welcome,
      thank_you: thank_you
    )
  end

  def create_templates
    create_bad_fit_template
    create_welcome_template
    create_thank_you_template
  end

  def create_bad_fit_template
    @bad_fit = organization.templates.create(
      name: 'Bad Fit',
      body:
        "Thank you very much for your interest. Unfortunately, we don't "\
        'have a good fit for you at this time. If anything changes we will '\
        'let you know.'
    )
  end

  def create_welcome_template
    @welcome = organization.templates.create(
      name: 'Welcome',
      body: "Hello this is #{organization.name}. We're so glad you are "\
      'interested in learning about opportunities here. We have a few '\
      'questions to ask you via text message.'
    )
  end

  def create_thank_you_template
    @thank_you = organization.templates.create(
      name: 'Thank You', body: 'Thanks for your interest!'
    )
  end

  def create_questions
    create_address_question
    create_transportation_question
    create_availability_question
  end

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

  def create_rules
    rules.create!(trigger: 'subscribe', actionable: survey.create_actionable)
    rules.create!(trigger: 'answer', actionable: survey.actionable)
    rules.create!(trigger: 'screen', actionable: thank_you.create_actionable)
  end

  def create_dummy_candidate_and_features
    candidate = user.create_candidate(status: 'Qualified')
    create_address_feature(candidate)
    create_availability_feature(candidate)
    create_transportation_feature(candidate)
  end

  def create_address_feature(candidate)
    candidate.candidate_features.create(label: 'Address', properties: {
                                          child_class: 'address',
                                          address: location.full_street_address,
                                          latitude: location.latitude,
                                          longitude: location.longitude,
                                          postal_code: location.postal_code,
                                          country: location.country,
                                          city: location.city
                                        })
  end

  def create_availability_feature(candidate)
    candidate.candidate_features.create(label: 'Availability', properties: {
                                          child_class: 'choice',
                                          choice_option: 'Hourly'
                                        })
  end

  def create_transportation_feature(candidate)
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
