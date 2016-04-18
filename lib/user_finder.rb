class UserFinder
  def initialize(attributes:)
    @attributes = attributes
  end

  def call
    user = User.find_by(phone_number: attributes[:phone_number])
    if user.blank?
      user = User.create(attributes)
    end
    user
  end

  private

  attr_reader :attributes
end
