class Seeder::SeedOrganization
  def self.call(account, organization)
    new(account, organization).call
  end

  def initialize(account, organization)
    @account = account
    @organization = organization
  end

  def call
    organization.tap do |organization|
      organization.create_subscription
      create_contact_stages
    end
  end

  private

  attr_reader :organization, :account

  def create_contact_stages
    ['New', 'Screened', 'Not Now', 'Scheduled'].each_with_index do |stage, i|
      organization.contact_stages.create(name: stage, rank: i + 1)
    end
  end
end
