class Notification::Base
  def initialize(contact)
    @contact = contact
  end

  attr_reader :contact
  delegate :organization, to: :contact
end
