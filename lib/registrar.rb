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

  attr_reader :account, :survey, :templates

  def setup_organization
    create_templates
    create_survey
    Registration::QuestionsCreator.new(survey).call
    create_rules
    Registration::CandidateFeaturesCreator.new(user).call
    create_subscription
  end

  def create_templates
    @templates = Registration::TemplatesCreator.new(organization)
    @templates.create_templates
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
      bad_fit: templates.bad_fit,
      welcome: templates.welcome,
      thank_you: templates.thank_you
      not_understood: templates.not_understood
    )
  end

  def create_rules
    rules.create!(trigger: 'subscribe', actionable: survey.create_actionable)
    rules.create!(trigger: 'answer', actionable: survey.actionable)
    rules.create!(trigger: 'screen',
      actionable: templates.thank_you.create_actionable)
  end

  def rules
    @rules ||= organization.rules
  end

  def organization
    @organization ||= account.organization
  end

  def user
    @user ||= account.user
  end
end
