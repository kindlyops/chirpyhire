class Broadcaster::Organization
  def self.broadcast(organization)
    new(organization).broadcast
  end

  def initialize(organization)
    @organization = organization
  end

  def broadcast
    OrganizationsChannel.broadcast_to(organization, organization_hash)
  end

  private

  attr_reader :organization

  def organization_hash
    JSON.parse(organization_string)
  end

  def organization_string
    OrganizationsController.render partial: 'organizations/organization',
                                   locals: locals
  end

  def locals
    { organization: organization.decorate }
  end
end
