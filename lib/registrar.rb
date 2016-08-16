class Registrar

  def initialize(account)
    @account = account
  end

  def register
    return unless organization.persisted?

    bad_fit = organization.templates.create(name: "Bad Fit", body: "Thank you very much for your interest. Unfortunately, we don't "\
      "have a good fit for you at this time. If anything changes we will let you know.")
    welcome = organization.templates.create(name: "Welcome", body: "Hello this is #{organization.name}. We're so glad you are interested in learning about opportunities here. We have a few questions to ask you via text message.")
    thank_you = organization.templates.create(name: "Thank You", body: "Thanks for your interest!")
    survey = organization.create_survey(bad_fit: bad_fit, welcome: welcome, thank_you: thank_you)

    organization.rules.create!(trigger: "subscribe", actionable: survey.create_actionable)
    organization.rules.create!(trigger: "answer", actionable: survey.actionable)
    organization.rules.create!(trigger: "screen", actionable: thank_you.create_actionable)

    organization.create_subscription(plan: Plan.first, state: "trialing", trial_message_limit: Plan::TRIAL_MESSAGE_LIMIT)
  end

  private

  attr_reader :account

  def organization
    @organization ||= account.organization
  end
end
