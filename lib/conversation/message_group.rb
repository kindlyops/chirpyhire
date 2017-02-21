class Conversation::MessageGroup
  attr_reader :group

  def initialize(group)
    @group = group
  end

  def inbound?
    group[0] == 'inbound'
  end

  def messages
    group[1]
  end

  def person
    messages.first.person
  end

  def organization
    messages.first.organization
  end

  def avatar_title
    return person.handle if inbound?
    organization.name
  end
end
