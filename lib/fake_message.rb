class FakeMessage
  attr_reader :sid

  def self.sid_sequence
    return 1 if Message.last.blank?
    Message.last.id + 1
  end

  def sid_sequence
    self.class.sid_sequence
  end

  def date_sent
    DateTime.current
  end

  def date_created
    DateTime.current
  end
end
