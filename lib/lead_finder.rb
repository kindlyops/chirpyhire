class LeadFinder
  def initialize(organization:, attributes:)
    @attributes = attributes
    @organization = organization
  end

  def call
    leads.find_or_create_by(user: lead_user)
  end

  private

  attr_reader :organization, :attributes

  def leads
    organization.leads
  end

  def lead_user
    @lead_user ||= begin
      lead_user = User.find_by(phone_number: attributes[:phone_number])
      if lead_user.blank?
        lead_user = User.create(attributes)
      end
      lead_user
    end
  end
end
