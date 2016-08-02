class Registrar

  def initialize(account)
    @account = account
  end

  def register
    return unless organization.persisted?

    survey = organization.create_survey
    survey.create_template(
      name: "Bad Fit - Default",
      organization: organization,
      body: "Thank you very much for your interest. Unfortunately, we don't "\
      "have a good fit for you at this time. If anything changes we will let you know.")
  end

  private

  attr_reader :account

  def organization
    @organization ||= account.organization
  end
end
