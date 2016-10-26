class UserFinder
  def self.find(organization:, attributes:)
    user = organization.users.find_by(phone_number: attributes[:phone_number])
    user = organization.users.create!(attributes) if user.blank?
    user
  end
end
