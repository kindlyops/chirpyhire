class Notification::Brokers::Base
  def initialize(broker_contact)
    @broker_contact = broker_contact
  end
end
