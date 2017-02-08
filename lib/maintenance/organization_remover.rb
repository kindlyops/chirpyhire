require 'twilio-ruby'

class Maintenance::OrganizationRemover
  def initialize(organization)
    @organization = organization
    @twilio_provisioner = TwilioProvisioner.new(organization)
  end

  def delete_organization(confirmed: false)
    raise "This is irreversible, and will delete all data for the organization\
    . Are you sure you want to delete #{organization.name}? \
    If so, pass in 'confirmed: true' to this method." unless confirmed

    twilio_provisioner.close_account
    delete_organization_internal
  end

  def close_organization(confirmed: false)
    raise "This is irreversible. \
    Are you sure you want to close the account for #{organization.name}? \
    If so, pass in 'confirmed: true' to this method." unless confirmed

    twilio_provisioner.close_account
  end

  private

  def delete_organization_internal
    delete_survey
    organization.subscription.delete
    delete_templates
    organization.location.delete
    delete_candidates
    delete_stages
    delete_accounts
    delete_rules
    delete_templates
    organization.delete
  end

  def delete_survey
    organization.survey.questions.each do |question|
      question.options.each(&:delete)
      question.delete
    end
    organization.survey.delete
  end

  def delete_templates
    organization.templates.each(&:delete)
  end

  def delete_stages
    organization.stages.each(&:delete)
  end

  def delete_candidates
    organization.candidates.each do |c|
      c.candidate_features.each(&:delete)
      c.delete
    end
  end

  def delete_accounts
    organization.accounts.each(&:delete)
    organization.users.each(&:delete)
  end

  def delete_rules
    organization.rules.each(&:delete)
  end

  attr_accessor :twilio_provisioner, :organization
end
