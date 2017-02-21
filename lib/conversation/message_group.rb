class Conversation::MessageGroup
  attr_reader :group

  def initialize(group)
    @group = group
  end

  def person?
    group[0] == :person
  end

  def bot?
    group[0] == :bot
  end

  def organization?
    group[0] == :organization
  end

  def messages
    group[1].sort_by(&:external_created_at).sort_by(&:id)
  end

  def person
    messages.first.person
  end

  def organization
    messages.first.organization
  end

  def avatar_title
    return person.handle if person?
    return 'ChirpyHire' if bot?
    organization.name
  end
end
